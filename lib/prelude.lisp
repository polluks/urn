(import core/prelude () :export)

(import data/alist () :export)
(import data/format () :export)
(import data/function () :export)
(import control/setq () :export)

(import math (even? odd? succ pred inc! dec!) :export)
(import math :export)
(import math/rational (rational rational? numerator denominator) :export)
(import math/rational rational :export)
(import math/numerics () :export)

(import test/assert (affirm) :export)

(defmacro exported-vars ()
  "Generate a struct with all variables exported in the current module.

   ### Example:
   ```cl
   > (let [(a 1)]
   .   (exported-vars))
   out = {\"a\" 1}
   ```

   ```cl :no-test
   (define x 1)
   (define y 2)
   (define z 3)
   (exported-vars) ;; { :x 1 :y 2 :z 3 }
   ```"
  (import compiler/resolve compiler)
  (import compiler/nodes compiler)
  (with (out '{})
    (for-pairs (name var) (compiler/scope-exported)
      (push-cdr! out name)
      (push-cdr! out (compiler/var->symbol var)))
    out))
