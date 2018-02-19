(import data/struct ())
(import lua/basic (load))
(import lua/io io)

(import urn/library ())
(import urn/logger logger)
(import urn/parser parser)
(import urn/range range)
(import urn/resolve/loop (compile))
(import urn/resolve/native ())
(import urn/resolve/scope scope)
(import urn/timer timer)
(import urn/traceback (traceback-plain))

(define path-escape
  "Lookup of characters to their escaped pattern variants."
  :hidden
  { "?" "(.*)"
    "." "%." "%" "%%"
    "^" "%^" "$" "%$"
    "+" "%+" "-" "%-" "*" "%*"
    "[" "%[" "]" "%]"
    "(" "%)" ")" "%)" })

(define lisp-extensions
  "List of extensions Lisp files may end in."
  :hidden
  '(".lisp" ".cl" ".urn"))

(defun try-handle (name)
  "Attempt to open NAME with the various extensions."
  :hidden
  (loop [(i 1)] [(> i (n lisp-extensions))]
    (if-with (handle (io/open (.. name (nth lisp-extensions i)) "r"))
      (values-list handle (.. name (nth lisp-extensions i)))
      (recur (succ i)))))

(defun simplify-path (path paths)
  "Simplify PATH, attempting to reduce it to a named module inside PATHS."
  :hidden
  (with (current path)
    (for-each search paths
      (with (sub (string/match path (.. "^" (string/gsub search "." path-escape) "$")))
        (when (and sub (< (n sub) (n current)))
          (set! current sub))))
    current))

(defun strip-extension (path)
  "Strip file extensions from PATH."
  (loop [(i 1)]
    [(> i (n lisp-extensions)) path]
    (with (suffix (nth lisp-extensions i))
      (if (string/ends-with? path suffix)
        (string/sub path 1 (- -1 (n suffix)))
        (recur (succ i))))))

(defun read-meta (state name entry)
  "Parse a single ENTRY in the library metadata, loading the appropriate data into STATE."
  :hidden
  (with (native (native))
    (case (type (.> entry :count))
      ["nil"]
      ["number" (set-native-arity! native (.> entry :count))]
      [?ty
       (logger/put-error! (.> state :log) (format nil "Expected number for {#name}'s count, got {#ty}"))])

    (case (type (.> entry :prec))
      ["nil"]
      ["number" (set-native-syntax-precedence! native (.> entry :prec))]
      [?ty
       (logger/put-error! (.> state :log) (format nil "Expected number for {#name}'s prec, got {#ty}"))])

    (case (type (.> entry :precs))
      ["nil"]
      ["list" (set-native-syntax-precedence! native (.> entry :precs))]
      [?ty
       (logger/put-error! (.> state :log) (format nil "Expected number for {#name}'s precs, got {#ty}"))])

    (when (.> entry :pure) (set-native-pure! native true))

    (case (type entry)
      ["expr"
       (with ((buffer max) (parse-template (.> entry :contents)))
         (set-native-syntax! native buffer)
         (unless (.> entry :count) (set-native-arity! native max)))]
      ["stmt"
       (with ((buffer max) (parse-template (.> entry :contents)))
         (set-native-syntax! native buffer)
         (unless (.> entry :count) (set-native-arity! native max)))
       (set-native-syntax-stmt! native true)]
      ["var"
       (set-native-bind-to! native (.> entry :contents))]
      [?ty
       (logger/put-error! (.> state :log) (format nil "Unknown meta type {#ty} for {#name}"))])

    (when-with (fold (.> entry :fold))
      (when (/= (type entry) "expr") (fail! (.. "Cannot have fold for non-expression " name)))
      (when (/= (.> entry :count) 2) (fail! (.. "Cannot have fold for length " (.> entry :count) " for " name)))
      (case fold
        ["l" (set-native-syntax-fold! native "left")]
        ["r" (set-native-syntax-fold! native "right")]
        [else (fail! (.. "Unknown fold " fold " for " name))]))

    (.<! entry :name name)

    (let [(lib-value (library-cache-value (.> state :libs) name))
          (meta-value (.> entry :value))]
      (cond
        [(and (/= lib-value nil) (/= meta-value nil))
         (fail! (.. "Duplicate value for " name ": in native and meta file"))]
        [(/= lib-value nil)
         (.<! entry :has-value true)
         (.<! entry :value lib-value)]
        [(/= meta-value nil)
         (.<! entry :has-value true)
         (set-library-cache-value! (.> state :libs) name meta-value)]
        [else]))

    (set-library-cache-meta! (.> state :libs) name native)))

(defun read-library (state name path lisp-handle)
  "Read a library from PATH, using an already existing LISP-HANDLE."
  :hidden
  (logger/put-verbose! (.> state :log) (.. "Loading " path " into " name))

  (let* [(unique-name (.. name "-" (n (library-cache-loaded (.> state :libs)))))
         (lib (library-of name unique-name path (.> state :root-scope)))
         (contents (self lisp-handle :read "*a"))]
    (self lisp-handle :close)

    ;; Attempt to load the native file
    (when-with (handle (io/open (.. path ".lib.lua") "r"))
      (with (contents (self handle :read "*a"))
        (self handle :close)
        (set-library-lua-contents! lib contents)

        (if-with ((fun err) (load contents (.. "@" name)))
          (case (list (xpcall fun traceback-plain))
            [(false ?msg)
             (logger/put-error! (.> state :log) (format nil "Cannot load {}.lib.lua ({:tostring})" path msg))]
            [(true (table? @ ?res) . _)
             (for-pairs (k v) res
               (if (string? k)
                 (set-library-cache-value! (.> state :libs) (.. unique-name "/" k) v)
                 (logger/put-warning! (.> state :log) (format nil "Non-string key '{:tostring}' when loading {}.lib.lua" k path))))]
            [_
             (logger/put-error! (.> state :log) (format nil "Received a non-table value from {}.lib.lua" path))])
          (logger/put-error! (.> state :log) (format nil "Cannot load {}.lib.lua ({})" path err)))))

    ;; Attempt to load the meta info
    (when-with (handle (io/open (.. path ".meta.lua") "r"))
      (with (contents (self handle :read "*a"))
        (self handle :close)

        (if-with ((fun err) (load contents (.. "@" name)))
          (case (list (xpcall fun traceback-plain))
            [(false ?msg)
             (logger/put-error! (.> state :log) (format nil "Cannot load {}.meta.lua ({:tostring})" path msg))]
            [(true (table? @ ?res) . _)
             (for-pairs (k v) res
               (if (string? k)
                 (read-meta state (.. unique-name "/" k) v)
                 (logger/put-warning! (.> state :log) (format nil "Non-string key '{:tostring}' when loading {}.meta.lua" k path))))]
            [_
             (logger/put-error! (.> state :log) (format nil "Received a non-table value from {}.meta.lua" path))])
          (logger/put-error! (.> state :log) (format nil "Cannot load {}.meta.lua ({})" path err)))))

    (timer/start-timer! (.> state :timer) (.. "[parse] " path) 2)

    ;; And parse all the things!
    (let* [((lexed range) (parser/lex (.> state :log) contents (.. path ".lisp")))
           (parsed (parser/parse (.> state :log) lexed))]

      (timer/stop-timer! (.> state :timer) (.. "[parse] " path))

      (with (compiled (compile
                        state
                        parsed
                        (library-scope lib)
                        path
                        (lambda (name)
                          (let* [(res ((.> state :loader) name))
                                 (module (car res))]
                            (when module
                              (.<! (library-depends lib) module true))
                            res))))


        (push! (library-cache-loaded (.> state :libs)) lib)

        ;; Extract documentation from the root node
        (when (string? (car compiled))
          (set-library-docs! lib (const-val (car compiled)))
          (remove-nth! compiled 1))

        ;; Append on to the complete output
        (set-library-lisp-lines! lib (range/range-lines range))
        (set-library-nodes! lib compiled)
        (for-each node compiled (push! (.> state :out) node))))

    (logger/put-verbose! (.> state :log) (.. "Loaded " path " into " name))
    lib))

(defun named-loader (state name)
  "Attempt to load NAME using the given compile STATE.

   This will search the compiler's load path for a module with the
   appropriate name."
  (with (cached (.> (library-cache-names (.> state :libs)) name))
    (cond
      [(= cached nil)
       (.<! (library-cache-names (.> state :libs)) name true)

       (let [(searched '())
             (paths (.> state :paths))]

         (loop [(i 1)]
           [(> i (n paths))
            (list nil (.. "Cannot find " (string/quoted name) ".\nLooked in " (concat searched ", ")))]

           ;; For every path, check if we've looked at this already and use it, otherwise
           ;; look it up on the filesystem and parse everything.
           (with (path (string/gsub (nth paths i) "%?" name))
             (case (path-loader state path)
               ;; If we've found the library then return
               [(?lib)
                (.<! (library-cache-names (.> state :libs)) name lib)
                (list lib)]
               ;; If we've got an error then propagate it
               [(false ?msg)
                (list false msg)]
               ;; Otherwise look at the next path
               [(nil _)
                (push! searched path)
                (recur (succ i))]))))]
      [(= cached true)
       (list false (.. "Already loading " (string/quoted name)))]
      [true (list cached)])))

(defun path-loader (state path)
  "Attempt to load PATH using the given compiler state.

   This will require an exact file name, optionally adding a file
   extension if needed."

  ;; First attempt to load from the main cache.
  (case (library-cache-at-path (.> state :libs) path)
    [nil
     ;; The library doesn't exist, let's try to find it.
     (let* [(name (strip-extension path))
            (full-path path)
            (handle nil)]

       ;; If we've not got a file extension then try to find an appropriate handle
       (if (= name path)
         (when-with ((handle' path') (try-handle path))
           (set! handle handle')
           (set! full-path path'))
         (set! handle (io/open path "r")))

       (case (library-cache-at-path (.> state :libs) full-path)
         [nil
          (if handle
            (progn
              ;; Ensure we don't get loops
              (set-library-cache-at-path! (.> state :libs) path true)
              (set-library-cache-at-path! (.> state :libs) full-path true)
              (with (lib (read-library state (simplify-path name (.> state :paths)) name handle))
                (set-library-cache-at-path! (.> state :libs) path lib)
                (set-library-cache-at-path! (.> state :libs) full-path lib)
                (list lib)))
            (list nil (.. "Cannot find " (string/quoted path))))]
         [true
          (when handle (self handle :close))
          (list false (.. "Already loading " (string/quoted full-path)))]
         [?cached
          (when handle (self handle :close))
          (format true "Loading " {} full-path)
          (list cached)]))]

    [true
     (list false (.. "Already loading " (string/quoted path)))]
    [?cached (list cached)]))
