local math = math or {}

if os.time and math.randomseed then
	-- N.B. Lua is a very silly language. It seeds the random number generator
	-- with the same value every time. So, here, we "fix" it.
	math.randomseed(os.time())
end

return {
	["abs"] =        { tag = "var", contents = "math.abs",        value = math.abs,        pure = true, },
	["acos"] =       { tag = "var", contents = "math.acos",       value = math.acos,       pure = true, },
	["asin"] =       { tag = "var", contents = "math.asin",       value = math.asin,       pure = true, },
	["atan"] =       { tag = "var", contents = "math.atan",       value = math.atan,       pure = true, },
	["ceil"] =       { tag = "var", contents = "math.ceil",       value = math.ceil,       pure = true, },
	["cos"] =        { tag = "var", contents = "math.cos",        value = math.cos,        pure = true, },
	["deg"] =        { tag = "var", contents = "math.deg",        value = math.deg,        pure = true, },
	["exp"] =        { tag = "var", contents = "math.exp",        value = math.exp,        pure = true, },
	["floor"] =      { tag = "var", contents = "math.floor",      value = math.floor,      pure = true, },
	["fmod"] =       { tag = "var", contents = "math.fmod",       value = math.fmod,       pure = true, },
	["huge"] =       { tag = "var", contents = "math.huge",       value = math.huge,       pure = true, },
	["log"] =        { tag = "var", contents = "math.log",        value = math.log,        pure = true, },
	["max"] =        { tag = "var", contents = "math.max",        value = math.max,        pure = true, },
	["maxinteger"] = { tag = "var", contents = "math.maxinteger", value = math.maxinteger, pure = true, },
	["min"] =        { tag = "var", contents = "math.min",        value = math.min,        pure = true, },
	["mininteger"] = { tag = "var", contents = "math.mininteger", value = math.mininteger, pure = true, },
	["modf"] =       { tag = "var", contents = "math.modf",       value = math.modf,       pure = true, },
	["pi"] =         { tag = "var", contents = "math.pi",         value = math.pi,         pure = true, },
	["rad"] =        { tag = "var", contents = "math.rad",        value = math.rad,        pure = true, },
	["random"] =     { tag = "var", contents = "math.random",     value = math.random,                  },
	["randomseed"] = { tag = "var", contents = "math.randomseed", value = math.randomseed,              },
	["sin"] =        { tag = "var", contents = "math.sin",        value = math.sin,        pure = true, },
	["sqrt"] =       { tag = "var", contents = "math.sqrt",       value = math.sqrt,       pure = true, },
	["tan"] =        { tag = "var", contents = "math.tan",        value = math.tan,        pure = true, },
	["tointeger"] =  { tag = "var", contents = "math.tointeger",  value = math.tointeger,  pure = true, },
	["type"] =       { tag = "var", contents = "math.type",       value = math.type,       pure = true, },
	["ult"] =        { tag = "var", contents = "math.ult",        value = math.ult,        pure = true, },
}
