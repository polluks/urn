if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	local counter = 0
	local function pretty(x)
		if type(x) == 'table' and x.tag then
			if x.tag == 'list' then
				local y = {}
				for i = 1, x.n do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' then
				return x.contents
			elseif x.tag == 'key' then
				return ":" .. x.value
			elseif x.tag == 'string' then
				return (("%q"):format(x.value):gsub("\n", "n"):gsub("\t", "\\9"))
			elseif x.tag == 'number' then
				return tostring(x.value)
			elseif x.tag.tag and x.tag.tag == 'symbol' and x.tag.contents == 'pair' then
				return '(pair ' .. pretty(x.fst) .. ' ' .. pretty(x.snd) .. ')'
			elseif x.tag == 'thunk' then
				return '<<thunk>>'
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
	if arg then
		if not arg.n then arg.n = #arg end
		if not arg.tag then arg.tag = "list" end
	else
		arg = { tag = "list", n = 0 }
	end
	return {
		['='] = function(x, y) return x == y end,
		['/='] = function(x, y) return x ~= y end,
		['<'] = function(x, y) return x < y end,
		['<='] = function(x, y) return x <= y end,
		['>'] = function(x, y) return x > y end,
		['>='] = function(x, y) return x >= y end,
		['+'] = function(x, y) return x + y end,
		['-'] = function(x, y) return x - y end,
		['*'] = function(x, y) return x * y end,
		['/'] = function(x, y) return x / y end,
		['%'] = function(x, y) return x % y end,
		['^'] = function(x, y) return x ^ y end,
		['..'] = function(x, y) return x .. y end,
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
		pretty = pretty,
		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end
			counter = counter + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(counter, name) }
		end,
		_G = _G, _ENV = _ENV, _VERSION = _VERSION, arg = arg,
		assert = assert, collectgarbage = collectgarbage,
		dofile = dofile, error = error,
		getmetatable = getmetatable, ipairs = ipairs,
		load = load, loadfile = loadfile,
		next = next, pairs = pairs,
		pcall = pcall, print = print,
		rawequal = rawequal, rawget = rawget,
		rawlen = rawlen, rawset = rawset,
		require = require, select = select,
		setmetatable = setmetatable, tonumber = tonumber,
		tostring = tostring, ["type#"] = type,
		xpcall = xpcall,
		["get-idx"] = function(x, i) return x[i] end,
		["set-idx!"] = function(x, k, v) x[k] = v end
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _temp = (function()
	return {
		['empty-struct'] = function() return {} end,
		['unpack'] = table.unpack or unpack,
		['iter-pairs'] = function(xs, f)
			for k, v in pairs(xs) do
				f(k, v)
			end
		end,
		concat = table.concat,
		insert = table.insert,
		move = table.move,
		pack = table.pack,
		remove = table.remove,
		sort = table.sort,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/table/".. k] = v end
local _temp = (function()
	return {
		byte = string.byte,
		char = string.char,
		dump = string.dump,
		find = string.find,
		format = string.format,
		gsub = string.gsub,
		len = string.len,
		lower = string.lower,
		match = string.match,
		rep = string.rep,
		reverse = string.reverse,
		sub = string.sub,
		upper = string.upper,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/string/".. k] = v end
local _temp = (function()
	return os
end)()
for k, v in pairs(_temp) do _libs["lib/lua/os/".. k] = v end
local _temp = (function()
	return io
end)()
for k, v in pairs(_temp) do _libs["lib/lua/io/".. k] = v end
local _temp = (function()
	return math
end)()
for k, v in pairs(_temp) do _libs["lib/lua/math/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, pretty1, error1, next1, pcall1, print1, getIdx1, setIdx_21_1, require1, tostring1, type_23_1, _23_1, concat1, remove1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, find1, format1, len1, rep1, sub1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, all1, nth1, pushCdr_21_1, removeNth_21_1, reverse1, caar1, cadr1, _2e2e_1, _23_s1, split1, struct1, _23_keys1, succ1, pred1, number_2d3e_string1, bool_2d3e_string1, error_21_1, print_21_1, fail_21_1, builtins1, visitQuote1, visitNode1, visitBlock1, visitList1, builtins2, builtinVars1, createState1, getVar1, getNode1, addUsage_21_1, addDefinition_21_1, definitionsVisitor1, definitionsVisit1, usagesVisit1, builtins3, traverseQuote1, traverseNode1, traverseBlock1, traverseList1, abs1, max1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, colored1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, builtins4, builtinVars2, hasSideEffect1, constant_3f_1, urn_2d3e_val1, val_2d3e_urn1, truthy_3f_1, makeProgn1, getConstantVal1, optimiseOnce1, optimise1
_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_3e_1 = _libs["lib/lua/basic/>"]
_3e3d_1 = _libs["lib/lua/basic/>="]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
slice1 = _libs["lib/lua/basic/slice"]
pretty1 = _libs["lib/lua/basic/pretty"]
error1 = _libs["lib/lua/basic/error"]
next1 = _libs["lib/lua/basic/next"]
pcall1 = _libs["lib/lua/basic/pcall"]
print1 = _libs["lib/lua/basic/print"]
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
require1 = _libs["lib/lua/basic/require"]
tostring1 = _libs["lib/lua/basic/tostring"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
remove1 = _libs["lib/lua/table/remove"]
unpack1 = _libs["lib/lua/table/unpack"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
iterPairs1 = _libs["lib/lua/table/iter-pairs"]
car1 = (function(xs1)
	return xs1[1]
end)
cdr1 = (function(xs2)
	return slice1(xs2, 2)
end)
list1 = (function(...)
	local xs3 = _pack(...) xs3.tag = "list"
	return xs3
end)
cons1 = (function(x2, xs4)
	return list1(x2, unpack1(xs4))
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
len1 = _libs["lib/lua/string/len"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	local r_31 = x4
	if r_31 then
		local r_41 = list_3f_1(x4)
		if r_41 then
			return (_23_1(x4) == 0)
		else
			return r_41
		end
	else
		return r_31
	end
end)
string_3f_1 = (function(x5)
	return (type1(x5) == "string")
end)
number_3f_1 = (function(x6)
	return (type1(x6) == "number")
end)
symbol_3f_1 = (function(x7)
	return (type1(x7) == "symbol")
end)
key_3f_1 = (function(x8)
	return (type1(x8) == "key")
end)
exists_3f_1 = (function(x9)
	return _21_1((type1(x9) == "nil"))
end)
type1 = (function(val1)
	local ty1 = type_23_1(val1)
	if (ty1 == "table") then
		local tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty1
	end
end)
car2 = (function(x10)
	local r_241 = type1(x10)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_241), 2)
	else
	end
	return car1(x10)
end)
cdr2 = (function(x11)
	local r_251 = type1(x11)
	if (r_251 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_251), 2)
	else
	end
	if nil_3f_1(x11) then
		return {tag = "list", n =0}
	else
		return cdr1(x11)
	end
end)
foldr1 = (function(f1, z1, xs5)
	local r_261 = type1(f1)
	if (r_261 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_261), 2)
	else
	end
	local r_381 = type1(xs5)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	if nil_3f_1(xs5) then
		return z1
	else
		local head1 = car2(xs5)
		local tail1 = cdr2(xs5)
		return f1(head1, foldr1(f1, z1, tail1))
	end
end)
map1 = (function(f2, xs6, acc1)
	local r_271 = type1(f2)
	if (r_271 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_271), 2)
	else
	end
	local r_391 = type1(xs6)
	if (r_391 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_391), 2)
	else
	end
	if _21_1(exists_3f_1(acc1)) then
		return map1(f2, xs6, {tag = "list", n =0})
	elseif nil_3f_1(xs6) then
		return reverse1(acc1)
	else
		return map1(f2, cdr2(xs6), cons1(f2(car2(xs6)), acc1))
	end
end)
all1 = (function(p1, xs7)
	local r_301 = type1(p1)
	if (r_301 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_301), 2)
	else
	end
	local r_431 = type1(xs7)
	if (r_431 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_431), 2)
	else
	end
	return foldr1((function(x12, y1)
		local r_441 = x12
		if r_441 then
			return y1
		else
			return r_441
		end
	end), true, map1(p1, xs7))
end)
nth1 = getIdx1
pushCdr_21_1 = (function(xs8, val2)
	local r_341 = type1(xs8)
	if (r_341 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_341), 2)
	else
	end
	local len2 = (_23_1(xs8) + 1)
	xs8["n"] = len2
	xs8[len2] = val2
	return xs8
end)
removeNth_21_1 = (function(li1, idx1)
	local r_361 = type1(li1)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_361), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx1)
end)
reverse1 = (function(xs9, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs9, {tag = "list", n =0})
	elseif nil_3f_1(xs9) then
		return acc2
	else
		return reverse1(cdr2(xs9), cons1(car2(xs9), acc2))
	end
end)
caar1 = (function(x13)
	return car2(car2(x13))
end)
cadr1 = (function(x14)
	return car2(cdr2(x14))
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
_23_s1 = len1
split1 = (function(text1, pattern1, limit1)
	local out1 = {tag = "list", n =0}
	local loop1 = true
	local start1 = 1
	local r_451 = nil
	r_451 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local temp1
			local r_461 = ("nil" == type_23_1(pos1))
			if r_461 then
				temp1 = r_461
			else
				local r_471 = (nth1(pos1, 1) == nil)
				if r_471 then
					temp1 = r_471
				else
					local r_481 = limit1
					if r_481 then
						temp1 = (_23_1(out1) >= limit1)
					else
						temp1 = r_481
					end
				end
			end
			if temp1 then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			else
				if car1(pos1) then
					pushCdr_21_1(out1, sub1(text1, start1, (car1(pos1) - 1)))
					start1 = (cadr1(pos1) + 1)
				else
					loop1 = false
				end
			end
			return r_451()
		else
		end
	end)
	r_451()
	return out1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out2 = emptyStruct1()
	local r_591 = _23_1(keys1)
	local r_601 = 2
	local r_571 = nil
	r_571 = (function(r_581)
		if (r_581 <= r_591) then
			local i1 = r_581
			local key2 = keys1[i1]
			local val3 = keys1[(1 + i1)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_571((r_581 + 2))
		else
		end
	end)
	r_571(1)
	return out2
end)
_23_keys1 = (function(st1)
	local cnt1 = 0
	iterPairs1(st1, (function()
		cnt1 = (cnt1 + 1)
		return nil
	end))
	return cnt1
end)
succ1 = (function(x15)
	return (x15 + 1)
end)
pred1 = (function(x16)
	return (x16 - 1)
end)
number_2d3e_string1 = tostring1
bool_2d3e_string1 = tostring1
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x17)
	return error_21_1(x17, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2 = node1["tag"]
		local temp2
		local r_1261 = (tag2 == "string")
		if r_1261 then
			temp2 = r_1261
		else
			local r_1271 = (tag2 == "number")
			if r_1271 then
				temp2 = r_1271
			else
				local r_1281 = (tag2 == "key")
				if r_1281 then
					temp2 = r_1281
				else
					temp2 = (tag2 == "symbol")
				end
			end
		end
		if temp2 then
			return nil
		elseif (tag2 == "list") then
			local first1 = nth1(node1, 1)
			local temp3
			local r_1291 = first1
			if r_1291 then
				temp3 = (first1["tag"] == "symbol")
			else
				temp3 = r_1291
			end
			if temp3 then
				local temp4
				local r_1301 = (first1["contents"] == "unquote")
				if r_1301 then
					temp4 = r_1301
				else
					temp4 = (first1["contents"] == "unquote-splice")
				end
				if temp4 then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1321 = node1
					local r_1351 = _23_1(r_1321)
					local r_1361 = 1
					local r_1331 = nil
					r_1331 = (function(r_1341)
						if (r_1341 <= r_1351) then
							local r_1311 = r_1341
							local sub2 = r_1321[r_1311]
							visitQuote1(sub2, visitor1, level1)
							return r_1331((r_1341 + 1))
						else
						end
					end)
					return r_1331(1)
				end
			else
				local r_1381 = node1
				local r_1411 = _23_1(r_1381)
				local r_1421 = 1
				local r_1391 = nil
				r_1391 = (function(r_1401)
					if (r_1401 <= r_1411) then
						local r_1371 = r_1401
						local sub3 = r_1381[r_1371]
						visitQuote1(sub3, visitor1, level1)
						return r_1391((r_1401 + 1))
					else
					end
				end)
				return r_1391(1)
			end
		elseif error_21_1 then
			return _2e2e_1("Unknown tag ", tag2)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3 = node2["tag"]
		local temp5
		local r_1431 = (tag3 == "string")
		if r_1431 then
			temp5 = r_1431
		else
			local r_1441 = (tag3 == "number")
			if r_1441 then
				temp5 = r_1441
			else
				local r_1451 = (tag3 == "key")
				if r_1451 then
					temp5 = r_1451
				else
					temp5 = (tag3 == "symbol")
				end
			end
		end
		if temp5 then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node2, 1)
			if (first2["tag"] == "symbol") then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1481 = _23_1(node2)
					local r_1491 = 1
					local r_1461 = nil
					r_1461 = (function(r_1471)
						if (r_1471 <= r_1481) then
							local i2 = r_1471
							local case1 = nth1(node2, i2)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1461((r_1471 + 1))
						else
						end
					end)
					return r_1461(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local temp6
					local r_1501 = (func1 == builtins1["unquote"])
					if r_1501 then
						temp6 = r_1501
					else
						temp6 = (func1 == builtins1["unquote-splice"])
					end
					if temp6 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp7
						local r_1511 = (func1 == builtins1["define"])
						if r_1511 then
							temp7 = r_1511
						else
							temp7 = (func1 == builtins1["define-macro"])
						end
						if temp7 then
							return visitNode1(nth1(node2, _23_1(node2)), visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail_21_1("Macros should have been expanded")
						else
							local temp8
							local r_1521 = (funct1 == "defined")
							if r_1521 then
								temp8 = r_1521
							else
								local r_1531 = (funct1 == "arg")
								if r_1531 then
									temp8 = r_1531
								else
									temp8 = (funct1 == "native")
								end
							end
							if temp8 then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail_21_1(_2e2e_1("Unknown kind ", funct1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		else
			return error_21_1(_2e2e_1("Unknown tag ", tag3))
		end
	end
end)
visitBlock1 = (function(node3, start2, visitor3)
	local r_1241 = _23_1(node3)
	local r_1251 = 1
	local r_1221 = nil
	r_1221 = (function(r_1231)
		if (r_1231 <= r_1241) then
			local i3 = r_1231
			visitNode1(nth1(node3, i3), visitor3)
			return r_1221((r_1231 + 1))
		else
		end
	end)
	return r_1221(start2)
end)
visitList1 = visitBlock1
builtins2 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
createState1 = (function()
	return struct1("vars", emptyStruct1(), "nodes", emptyStruct1())
end)
getVar1 = (function(state1, var1)
	local entry1 = state1["vars"][var1]
	if entry1 then
	else
		entry1 = struct1("var", var1, "usages", struct1(), "defs", struct1(), "active", false)
		state1["vars"][var1] = entry1
	end
	return entry1
end)
getNode1 = (function(state2, node4)
	local entry2 = state2["nodes"][node4]
	if entry2 then
	else
		entry2 = struct1("uses", {tag = "list", n =0})
		state2["nodes"][node4] = entry2
	end
	return entry2
end)
addUsage_21_1 = (function(state3, var2, node5)
	local varMeta1 = getVar1(state3, var2)
	local nodeMeta1 = getNode1(state3, node5)
	varMeta1["usages"][node5] = true
	varMeta1["active"] = true
	nodeMeta1["uses"][var2] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var3, node6, kind1, value1)
	local varMeta2 = getVar1(state4, var3)
	if value1 then
		local nodeMeta2 = getNode1(state4, value1)
		if nodeMeta2["defines"] then
			error_21_1("Value defines multiple variables")
		else
		end
		nodeMeta2["defines"] = var3
	else
	end
	varMeta2["defs"][node6] = struct1("tag", kind1, "value", value1)
	return nil
end)
definitionsVisitor1 = (function(state5, node7)
	local temp9
	local r_1061 = list_3f_1(node7)
	if r_1061 then
		temp9 = symbol_3f_1(car2(node7))
	else
		temp9 = r_1061
	end
	if temp9 then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_1081 = nth1(node7, 2)
			local r_1111 = _23_1(r_1081)
			local r_1121 = 1
			local r_1091 = nil
			r_1091 = (function(r_1101)
				if (r_1101 <= r_1111) then
					local r_1071 = r_1101
					local arg1 = r_1081[r_1071]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_1091((r_1101 + 1))
				else
				end
			end)
			return r_1091(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local temp10
			local r_1131 = (func2 == builtins2["define"])
			if r_1131 then
				temp10 = r_1131
			else
				temp10 = (func2 == builtins2["define-macro"])
			end
			if temp10 then
				return addDefinition_21_1(state5, node7["defVar"], node7, "define", nth1(node7, _23_1(node7)))
			elseif (func2 == builtins2["define-native"]) then
				return addDefinition_21_1(state5, node7["defVar"], node7, "native")
			else
			end
		end
	else
		local temp11
		local r_1141 = list_3f_1(node7)
		if r_1141 then
			local r_1151 = list_3f_1(car2(node7))
			if r_1151 then
				local r_1161 = symbol_3f_1(caar1(node7))
				if r_1161 then
					temp11 = (caar1(node7)["var"] == builtins2["lambda"])
				else
					temp11 = r_1161
				end
			else
				temp11 = r_1151
			end
		else
			temp11 = r_1141
		end
		if temp11 then
			local lam1 = car2(node7)
			local args2 = nth1(lam1, 2)
			local offset1 = 1
			local r_1191 = _23_1(args2)
			local r_1201 = 1
			local r_1171 = nil
			r_1171 = (function(r_1181)
				if (r_1181 <= r_1191) then
					local i4 = r_1181
					local arg2 = nth1(args2, i4)
					local val4 = nth1(node7, (i4 + offset1))
					if arg2["var"]["isVariadic"] then
						local count1 = (_23_1(node7) - _23_1(args2))
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state5, arg2["var"], arg2, "arg", arg2)
					else
						addDefinition_21_1(state5, arg2["var"], arg2, "let", (function(r_1211)
							if r_1211 then
								return r_1211
							else
								return struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
							end
						end)(val4))
					end
					return r_1171((r_1181 + 1))
				else
				end
			end)
			r_1171(1)
			local visitor4 = (function(r_1661)
				return definitionsVisitor1(state5, r_1661)
			end)
			visitList1(node7, 2, visitor4)
			visitBlock1(lam1, 3, visitor4)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_1671)
		return definitionsVisitor1(state6, r_1671)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = {tag = "list", n =0}
	local visited1 = emptyStruct1()
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val5 = def1["value"]
				local temp12
				local r_1651 = val5
				if r_1651 then
					temp12 = _21_1(visited1[val5])
				else
					temp12 = r_1651
				end
				if temp12 then
					return pushCdr_21_1(queue1, val5)
				else
				end
			end))
		else
		end
	end)
	local visit1 = (function(node8)
		if visited1[node8] then
			return false
		else
			visited1[node8] = true
			if symbol_3f_1(node8) then
				addUsage1(node8["var"], node8)
				return true
			else
				local temp13
				local r_1611 = list_3f_1(node8)
				if r_1611 then
					local r_1621 = (_23_1(node8) > 0)
					if r_1621 then
						temp13 = symbol_3f_1(car2(node8))
					else
						temp13 = r_1621
					end
				else
					temp13 = r_1611
				end
				if temp13 then
					local func3 = car2(node8)["var"]
					local temp14
					local r_1631 = (func3 == builtins2["set!"])
					if r_1631 then
						temp14 = r_1631
					else
						local r_1641 = (func3 == builtins2["define"])
						if r_1641 then
							temp14 = r_1641
						else
							temp14 = (func3 == builtins2["define-macro"])
						end
					end
					if temp14 then
						if pred2(nth1(node8, 3)) then
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end
		end
	end)
	local r_1551 = nodes2
	local r_1581 = _23_1(r_1551)
	local r_1591 = 1
	local r_1561 = nil
	r_1561 = (function(r_1571)
		if (r_1571 <= r_1581) then
			local r_1541 = r_1571
			local node9 = r_1551[r_1541]
			pushCdr_21_1(queue1, node9)
			return r_1561((r_1571 + 1))
		else
		end
	end)
	r_1561(1)
	local r_1601 = nil
	r_1601 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1601()
		else
		end
	end)
	return r_1601()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
traverseQuote1 = (function(node10, visitor5, level2)
	if (level2 == 0) then
		return traverseNode1(node10, visitor5)
	else
		local tag4 = node10["tag"]
		local temp15
		local r_1791 = (tag4 == "string")
		if r_1791 then
			temp15 = r_1791
		else
			local r_1801 = (tag4 == "number")
			if r_1801 then
				temp15 = r_1801
			else
				local r_1811 = (tag4 == "key")
				if r_1811 then
					temp15 = r_1811
				else
					temp15 = (tag4 == "symbol")
				end
			end
		end
		if temp15 then
			return node10
		elseif (tag4 == "list") then
			local first3 = nth1(node10, 1)
			local temp16
			local r_1821 = first3
			if r_1821 then
				temp16 = (first3["tag"] == "symbol")
			else
				temp16 = r_1821
			end
			if temp16 then
				local temp17
				local r_1831 = (first3["contents"] == "unquote")
				if r_1831 then
					temp17 = r_1831
				else
					temp17 = (first3["contents"] == "unquote-splice")
				end
				if temp17 then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor5, pred1(level2))
					return node10
				elseif (first3["contents"] == "quasiquote") then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor5, succ1(level2))
					return node10
				else
					local r_1861 = _23_1(node10)
					local r_1871 = 1
					local r_1841 = nil
					r_1841 = (function(r_1851)
						if (r_1851 <= r_1861) then
							local i5 = r_1851
							node10[i5] = traverseQuote1(nth1(node10, i5), visitor5, level2)
							return r_1841((r_1851 + 1))
						else
						end
					end)
					r_1841(1)
					return node10
				end
			else
				local r_1901 = _23_1(node10)
				local r_1911 = 1
				local r_1881 = nil
				r_1881 = (function(r_1891)
					if (r_1891 <= r_1901) then
						local i6 = r_1891
						node10[i6] = traverseQuote1(nth1(node10, i6), visitor5, level2)
						return r_1881((r_1891 + 1))
					else
					end
				end)
				r_1881(1)
				return node10
			end
		elseif error_21_1 then
			return _2e2e_1("Unknown tag ", tag4)
		else
			_error("unmatched item")
		end
	end
end)
traverseNode1 = (function(node11, visitor6)
	local tag5 = node11["tag"]
	local temp18
	local r_1681 = (tag5 == "string")
	if r_1681 then
		temp18 = r_1681
	else
		local r_1691 = (tag5 == "number")
		if r_1691 then
			temp18 = r_1691
		else
			local r_1701 = (tag5 == "key")
			if r_1701 then
				temp18 = r_1701
			else
				temp18 = (tag5 == "symbol")
			end
		end
	end
	if temp18 then
		return visitor6(node11)
	elseif (tag5 == "list") then
		local first4 = car2(node11)
		first4 = visitor6(first4)
		node11[1] = first4
		if (first4["tag"] == "symbol") then
			local func4 = first4["var"]
			local funct2 = func4["tag"]
			if (func4 == builtins3["lambda"]) then
				traverseBlock1(node11, 3, visitor6)
				return visitor6(node11)
			elseif (func4 == builtins3["cond"]) then
				local r_1941 = _23_1(node11)
				local r_1951 = 1
				local r_1921 = nil
				r_1921 = (function(r_1931)
					if (r_1931 <= r_1941) then
						local i7 = r_1931
						local case2 = nth1(node11, i7)
						case2[1] = traverseNode1(nth1(case2, 1), visitor6)
						traverseBlock1(case2, 2, visitor6)
						return r_1921((r_1931 + 1))
					else
					end
				end)
				r_1921(2)
				return visitor6(node11)
			elseif (func4 == builtins3["set!"]) then
				node11[3] = traverseNode1(nth1(node11, 3), visitor6)
				return visitor6(node11)
			elseif (func4 == builtins3["quote"]) then
				return visitor6(node11)
			elseif (func4 == builtins3["quasiquote"]) then
				node11[2] = traverseQuote1(nth1(node11, 2), visitor6, 1)
				return visitor6(node11)
			else
				local temp19
				local r_1961 = (func4 == builtins3["unquote"])
				if r_1961 then
					temp19 = r_1961
				else
					temp19 = (func4 == builtins3["unquote-splice"])
				end
				if temp19 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp20
					local r_1971 = (func4 == builtins3["define"])
					if r_1971 then
						temp20 = r_1971
					else
						temp20 = (func4 == builtins3["define-macro"])
					end
					if temp20 then
						node11[_23_1(node11)] = traverseNode1(nth1(node11, _23_1(node11)), visitor6)
						return visitor6(node11)
					elseif (func4 == builtins3["define-native"]) then
						return visitor6(node11)
					elseif (func4 == builtins3["import"]) then
						return visitor6(node11)
					else
						local temp21
						local r_1981 = (funct2 == "defined")
						if r_1981 then
							temp21 = r_1981
						else
							local r_1991 = (funct2 == "arg")
							if r_1991 then
								temp21 = r_1991
							else
								local r_2001 = (funct2 == "native")
								if r_2001 then
									temp21 = r_2001
								else
									temp21 = (funct2 == "macro")
								end
							end
						end
						if temp21 then
							traverseList1(node11, 1, visitor6)
							return visitor6(node11)
						else
							return fail_21_1(_2e2e_1("Unknown kind ", funct2, " for variable ", func4["name"]))
						end
					end
				end
			end
		else
			traverseList1(node11, 1, visitor6)
			return visitor6(node11)
		end
	else
		return error_21_1(_2e2e_1("Unknown tag ", tag5))
	end
end)
traverseBlock1 = (function(node12, start3, visitor7)
	local offset2 = 0
	local r_1731 = _23_1(node12)
	local r_1741 = 1
	local r_1711 = nil
	r_1711 = (function(r_1721)
		if (r_1721 <= r_1731) then
			local i8 = r_1721
			if nil_3f_1(nth1(node12, (i8 + 0))) then
				print_21_1("node", pretty1(node12))
			else
			end
			local result1 = traverseNode1(nth1(node12, (i8 + 0)), visitor7)
			node12[i8] = result1
			return r_1711((r_1721 + 1))
		else
		end
	end)
	r_1711(start3)
	return node12
end)
traverseList1 = (function(node13, start4, visitor8)
	local r_1771 = _23_1(node13)
	local r_1781 = 1
	local r_1751 = nil
	r_1751 = (function(r_1761)
		if (r_1761 <= r_1771) then
			local i9 = r_1761
			node13[i9] = traverseNode1(nth1(node13, i9), visitor8)
			return r_1751((r_1761 + 1))
		else
		end
	end)
	r_1751(start4)
	return node13
end)
abs1 = _libs["lib/lua/math/abs"]
max1 = _libs["lib/lua/math/max"]
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level3)
	verbosity1["value"] = level3
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value2)
	showExplain1["value"] = value2
	return nil
end)
colored1 = (function(col1, msg1)
	return _2e2e_1("\27[", col1, "m", msg1, "\27[0m")
end)
printError_21_1 = (function(msg2)
	local lines1 = split1(msg2, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg3)
	local lines2 = split1(msg3, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg4)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg4))
	else
	end
end)
printDebug_21_1 = (function(msg5)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg5))
	else
	end
end)
formatPosition1 = (function(pos2)
	return _2e2e_1(pos2["line"], ":", pos2["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node14)
	local temp22
	local r_2011 = node14["range"]
	if r_2011 then
		temp22 = node14["contents"]
	else
		temp22 = r_2011
	end
	if temp22 then
		return format1("%s (%q)", formatRange1(node14["range"]), node14["contents"])
	elseif node14["range"] then
		return formatRange1(node14["range"])
	elseif node14["macro"] then
		local macro1 = node14["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp23
		local r_2111 = node14["start"]
		if r_2111 then
			temp23 = node14["finish"]
		else
			temp23 = r_2111
		end
		if temp23 then
			return formatRange1(node14)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node15)
	local result2 = nil
	local r_2021 = nil
	r_2021 = (function()
		local temp24
		local r_2031 = node15
		if r_2031 then
			temp24 = _21_1(result2)
		else
			temp24 = r_2031
		end
		if temp24 then
			result2 = node15["range"]
			node15 = node15["parent"]
			return r_2021()
		else
		end
	end)
	r_2021()
	return result2
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous1 = -1
	local file1 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(node16, max2)
		if string_3f_1(node16) then
			return max2
		else
			return max1(max2, node16["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_2141 = _23_1(entries1)
	local r_2151 = 2
	local r_2121 = nil
	r_2121 = (function(r_2131)
		if (r_2131 <= r_2141) then
			local i10 = r_2131
			local position1 = entries1[i10]
			local message1 = entries1[succ1(i10)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print_21_1(_2e2e_1("\27[95m ", file1, "\27[0m"))
			else
				local temp25
				local r_2161 = (previous1 ~= -1)
				if r_2161 then
					temp25 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp25 = r_2161
				end
				if temp25 then
					print_21_1(" \27[92m...\27[0m")
				else
				end
			end
			previous1 = position1["start"]["line"]
			print_21_1(format1(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local temp26
				local r_2171 = position1["finish"]
				if r_2171 then
					temp26 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp26 = r_2171
				end
				if temp26 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_2121((r_2131 + 2))
		else
		end
	end)
	return r_2121(1)
end)
putTrace_21_1 = (function(node17)
	local previous2 = nil
	local r_2041 = nil
	r_2041 = (function()
		if node17 then
			local formatted1 = formatNode1(node17)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node17 = node17["parent"]
			return r_2041()
		else
		end
	end)
	return r_2041()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_2061 = lines3
		local r_2091 = _23_1(r_2061)
		local r_2101 = 1
		local r_2071 = nil
		r_2071 = (function(r_2081)
			if (r_2081 <= r_2091) then
				local r_2051 = r_2081
				local line1 = r_2061[r_2051]
				print_21_1(_2e2e_1("  ", line1))
				return r_2071((r_2081 + 1))
			else
			end
		end)
		return r_2071(1)
	else
	end
end)
errorPositions_21_1 = (function(node18, msg6)
	printError_21_1(msg6)
	putTrace_21_1(node18)
	local source1 = getSource1(node18)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
builtins4 = require1("tacky.analysis.resolve")["builtins"]
builtinVars2 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node19)
	local tag6 = type1(node19)
	local temp27
	local r_891 = (tag6 == "number")
	if r_891 then
		temp27 = r_891
	else
		local r_901 = (tag6 == "string")
		if r_901 then
			temp27 = r_901
		else
			local r_911 = (tag6 == "key")
			if r_911 then
				temp27 = r_911
			else
				temp27 = (tag6 == "symbol")
			end
		end
	end
	if temp27 then
		return false
	elseif (tag6 == "list") then
		local fst1 = car2(node19)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_921 = (var5 ~= builtins4["lambda"])
			if r_921 then
				return (var5 ~= builtins4["quote"])
			else
				return r_921
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node20)
	local r_931 = string_3f_1(node20)
	if r_931 then
		return r_931
	else
		local r_941 = number_3f_1(node20)
		if r_941 then
			return r_941
		else
			return key_3f_1(node20)
		end
	end
end)
urn_2d3e_val1 = (function(node21)
	if string_3f_1(node21) then
		return node21["value"]
	elseif number_3f_1(node21) then
		return node21["value"]
	elseif key_3f_1(node21) then
		return node21["value"]
	else
		_error("unmatched item")
	end
end)
val_2d3e_urn1 = (function(val6)
	local ty2 = type_23_1(val6)
	if (ty2 == "string") then
		return struct1("tag", "string", "value", val6)
	elseif (ty2 == "number") then
		return struct1("tag", "number", "value", val6)
	elseif (ty2 == "nil") then
		return struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
	elseif (ty2 == "boolean") then
		return struct1("tag", "symbol", "contents", bool_2d3e_string1(val6), "var", builtinVars2[bool_2d3e_string1(val6)])
	else
		_error("unmatched item")
	end
end)
truthy_3f_1 = (function(node22)
	local temp28
	local r_951 = string_3f_1(node22)
	if r_951 then
		temp28 = r_951
	else
		local r_961 = key_3f_1(node22)
		if r_961 then
			temp28 = r_961
		else
			temp28 = number_3f_1(node22)
		end
	end
	if temp28 then
		return true
	elseif symbol_3f_1(node22) then
		return (builtinVars2["true"] == node22["var"])
	else
		return false
	end
end)
makeProgn1 = (function(body1)
	local lambda1 = struct1("tag", "symbol", "contents", "lambda", "var", builtins4["lambda"])
	return {tag = "list", n =1, (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = lambda1
		_result[2 + _offset] = {tag = "list", n =0}
		_temp = body1
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	}
end)
getConstantVal1 = (function(lookup1, sym1)
	local def2 = getVar1(lookup1, sym1["var"])
	if (1 == _23_keys1(def2["defs"])) then
		local ent1 = nth1(list1(next1(def2["defs"])), 2)
		local val7 = ent1["value"]
		local temp29
		local r_971 = string_3f_1(val7)
		if r_971 then
			temp29 = r_971
		else
			local r_981 = number_3f_1(val7)
			if r_981 then
				temp29 = r_981
			else
				temp29 = key_3f_1(val7)
			end
		end
		if temp29 then
			return val7
		else
			return nil
		end
	else
	end
end)
optimiseOnce1 = (function(nodes3, state8)
	local changed1 = false
	local r_1011 = 1
	local r_1021 = -1
	local r_991 = nil
	r_991 = (function(r_1001)
		local temp30
		if false then
			temp30 = (r_1001 <= 1)
		else
			temp30 = (r_1001 >= 1)
		end
		if temp30 then
			local i11 = r_1001
			local node23 = nth1(nodes3, i11)
			local temp31
			local r_1031 = list_3f_1(node23)
			if r_1031 then
				local r_1041 = (_23_1(node23) > 0)
				if r_1041 then
					local r_1051 = symbol_3f_1(car2(node23))
					if r_1051 then
						temp31 = (car2(node23)["var"] == builtins4["import"])
					else
						temp31 = r_1051
					end
				else
					temp31 = r_1041
				end
			else
				temp31 = r_1031
			end
			if temp31 then
				if (i11 == _23_1(nodes3)) then
					nodes3[i11] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
				else
					removeNth_21_1(nodes3, i11)
				end
				changed1 = true
			else
			end
			return r_991((r_1001 + -1))
		else
		end
	end)
	r_991(_23_1(nodes3))
	local r_2201 = 1
	local r_2211 = -1
	local r_2181 = nil
	r_2181 = (function(r_2191)
		local temp32
		if false then
			temp32 = (r_2191 <= 1)
		else
			temp32 = (r_2191 >= 1)
		end
		if temp32 then
			local i12 = r_2191
			local node24 = nth1(nodes3, i12)
			if _21_1(hasSideEffect1(node24)) then
				removeNth_21_1(nodes3, i12)
				changed1 = true
			else
			end
			return r_2181((r_2191 + -1))
		else
		end
	end)
	r_2181(pred1(_23_1(nodes3)))
	traverseList1(nodes3, 1, (function(node25)
		local temp33
		local r_2221 = list_3f_1(node25)
		if r_2221 then
			temp33 = all1(constant_3f_1, cdr2(node25))
		else
			temp33 = r_2221
		end
		if temp33 then
			local head2 = car2(node25)
			local meta1
			local r_2251 = symbol_3f_1(head2)
			if r_2251 then
				local r_2261 = _21_1(head2["folded"])
				if r_2261 then
					local r_2271 = (head2["var"]["tag"] == "native")
					if r_2271 then
						meta1 = state8["meta"][head2["var"]["fullName"]]
					else
						meta1 = r_2271
					end
				else
					meta1 = r_2261
				end
			else
				meta1 = r_2251
			end
			local temp34
			local r_2231 = meta1
			if r_2231 then
				local r_2241 = meta1["pure"]
				if r_2241 then
					temp34 = meta1["value"]
				else
					temp34 = r_2241
				end
			else
				temp34 = r_2231
			end
			if temp34 then
				local res1 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr2(node25)))))
				if car2(res1) then
					return val_2d3e_urn1(nth1(res1, 2))
				else
					head2["folded"] = true
					printWarning_21_1(_2e2e_1("Cannot execute constant expression"))
					putTrace_21_1(node25)
					putLines_21_1(true, getSource1(node25), _2e2e_1("Executed ", pretty1(node25), ", failed with: ", nth1(res1, 2)))
					return node25
				end
			else
				return node25
			end
		else
			return node25
		end
	end))
	traverseList1(nodes3, 1, (function(node26)
		local temp35
		local r_2281 = list_3f_1(node26)
		if r_2281 then
			local r_2291 = symbol_3f_1(car2(node26))
			if r_2291 then
				temp35 = (car2(node26)["var"] == builtins4["cond"])
			else
				temp35 = r_2291
			end
		else
			temp35 = r_2281
		end
		if temp35 then
			local final1 = nil
			local r_2321 = _23_1(node26)
			local r_2331 = 1
			local r_2301 = nil
			r_2301 = (function(r_2311)
				if (r_2311 <= r_2321) then
					local i13 = r_2311
					local case3 = nth1(node26, i13)
					if final1 then
						changed1 = true
						removeNth_21_1(node26, final1)
					elseif truthy_3f_1(car2(nth1(node26, i13))) then
						final1 = succ1(i13)
					else
					end
					return r_2301((r_2311 + 1))
				else
				end
			end)
			r_2301(2)
			local temp36
			local r_2341 = (_23_1(node26) == 2)
			if r_2341 then
				temp36 = truthy_3f_1(car2(nth1(node26, 2)))
			else
				temp36 = r_2341
			end
			if temp36 then
				changed1 = true
				local body2 = cdr2(nth1(node26, 2))
				if (_23_1(body2) == 1) then
					return car2(body2)
				else
					return makeProgn1(cdr2(nth1(node26, 2)))
				end
			else
				return node26
			end
		else
			return node26
		end
	end))
	local lookup2 = createState1()
	definitionsVisit1(lookup2, nodes3)
	usagesVisit1(lookup2, nodes3, hasSideEffect1)
	local r_2371 = 1
	local r_2381 = -1
	local r_2351 = nil
	r_2351 = (function(r_2361)
		local temp37
		if false then
			temp37 = (r_2361 <= 1)
		else
			temp37 = (r_2361 >= 1)
		end
		if temp37 then
			local i14 = r_2361
			local node27 = nth1(nodes3, i14)
			local temp38
			local r_2391 = node27["defVar"]
			if r_2391 then
				temp38 = _21_1(getVar1(lookup2, node27["defVar"])["active"])
			else
				temp38 = r_2391
			end
			if temp38 then
				if (i14 == _23_1(nodes3)) then
					nodes3[i14] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
				else
					removeNth_21_1(nodes3, i14)
				end
				changed1 = true
			else
			end
			return r_2351((r_2361 + -1))
		else
		end
	end)
	r_2351(_23_1(nodes3))
	traverseList1(nodes3, 1, (function(node28)
		if symbol_3f_1(node28) then
			local var6 = getConstantVal1(lookup2, node28)
			if var6 then
				changed1 = true
				return var6
			else
				return node28
			end
		else
			return node28
		end
	end))
	return changed1
end)
optimise1 = (function(nodes4, state9)
	if state9 then
	else
		state9 = struct1("meta", emptyStruct1())
	end
	local iteration1 = 0
	local changed2 = true
	local r_2401 = nil
	r_2401 = (function()
		local temp39
		local r_2411 = changed2
		if r_2411 then
			temp39 = (iteration1 < 10)
		else
			temp39 = r_2411
		end
		if temp39 then
			changed2 = optimiseOnce1(nodes4, state9)
			iteration1 = (iteration1 + 1)
			return r_2401()
		else
		end
	end)
	r_2401()
	return nodes4
end)
return optimise1
