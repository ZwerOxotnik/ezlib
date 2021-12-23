local tremove = table.remove
local tinsert = table.insert

local function log_print(tbl, indent)
	local freturn = 1
	if not indent then
		indent = 0
		freturn = 0
	end
	local toprint = "\n" .. string.rep("	", indent) .. "{\r\n"
	indent = indent + 1
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			toprint = toprint .. string.rep("	", indent)
			if (type(k) == "number") then
				toprint = toprint .. "[" .. k .. "] = "
			elseif (type(k) == "string") then
				toprint = toprint	.. k ..	" = "
			end
			if (type(v) == "number") then
				toprint = toprint .. v .. ",\r\n"
			elseif (type(v) == "string") then
				toprint = toprint .. "" .. v .. ",\r\n"
			elseif (type(v) == "table") then
				toprint = toprint .. log_print(v, indent + 1) .. ",\r\n"
			else
				toprint = toprint .. "" .. tostring(v) .. ",\r\n"
			end
		end
		toprint = toprint .. string.rep("	", indent - 1) .. "}"
		if freturn == 0 then
			log(toprint)
		else
			return toprint
		end
	else
		if freturn == 0 then
			log(tbl)
		else
			return tbl
		end
	end
end

remote.add_interface("ezlib",{
	log_print = function(tbl, indent)
	local freturn = 1
	if not indent then
		indent = 0
		freturn = 0
	end
	local toprint = "\n" .. string.rep("	", indent) .. "{\r\n"
	indent = indent + 1
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			toprint = toprint .. string.rep("	", indent)
			if (type(k) == "number") then
				toprint = toprint .. "[" .. k .. "] = "
			elseif (type(k) == "string") then
				toprint = toprint	.. k ..	" = "
			end
			if (type(v) == "number") then
				toprint = toprint .. v .. ",\r\n"
			elseif (type(v) == "string") then
				toprint = toprint .. "" .. v .. ",\r\n"
			elseif (type(v) == "table") then
				toprint = toprint .. log_print(v, indent + 1) .. ",\r\n"
			else
				toprint = toprint .. "" .. tostring(v) .. ",\r\n"
			end
		end
		toprint = toprint .. string.rep("	", indent - 1) .. "}"
		if freturn == 0 then
			log(toprint)
		else
			return toprint
		end
	else
		if freturn == 0 then
			log(tbl)
		else
			return tbl
		end
	end
	end,

	tbl_remove = function(list1, list2)
	local print = "ezlib.tbl.remove\n---------------------------------------------------------------------------------------------\n"
	if list2 ~= nil then
		local list3 = {}
		for _, ing in pairs(list1) do
			tinsert(list3, ing)
		end
		local z = 0
		for x, ing in pairs(list1) do
			if type(list2) == "table" then
				for y,ing2 in pairs(list2) do
					if ing == ing2 then
						tremove(list3, (x - z))
						z = z + 1
						break
					end
				end
			else
				if list1[x] == list2 then
					tremove(list1, x)
				end
			end
		end
		if type(list2) ~= "string" then
			print = print .. "	Removed ".. (#list1 - #list3) .. " items.\n"
		else
			print = print .. "	Removed string ".. list2 .. ".\n"
		end
		if ezlib.debug_self_self then
			print = print .. "	Returning:" .. log_print(list1, 0)
			log(print .. "	\n---------------------------------------------------------------------------------------------")
		end
		return list3
	else
		if ezlib.debug_self_self then
			print = print .. "	list2 is empty.\n	Returning:" .. log_print(list1, 0)
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
		return list1
	end
	end,

	tbl_add = function(list1, list2, list3, list4, list5)
	local list = {}
	local print = "ezlib.tbl.add\n---------------------------------------------------------------------------------------------\n"
	if list1 ~= nil and type(list1) == "table" then
		for y,ing in pairs(list1) do
			tinsert(list, ing)
		end
		print = print .. "	Table_1 added as table\n"
	elseif type(list1) == "string" then
		tinsert(list, list1)
		print = print .. "	Table_1 added as string\n"
	end

	if list2 ~= nil and type(list2) == "table" then
		for y,ing in pairs(list2) do
			tinsert(list, ing)
		end
		print = print .. "	Table_2 added as table\n"
	elseif type(list2) == "string" then
		tinsert(list, list2)
		print = print .. "	Table_2 added as string\n"
	end

	if list3 ~= nil and type(list3) == "table" then
		for y,ing in pairs(list3) do
			tinsert(list, ing)
		end
		print = print .. "	Table_3 added as table\n"
	elseif type(list3) == "string" then
		tinsert(list, list3)
		print = print .. "	Table_3 added as string\n"
	end

	if list4 ~= nil and type(list4) == "table" then
		for y,ing in pairs(list4) do
			tinsert(list, ing)
		end
		print = print .. "	Table_4 added as table\n"
	elseif type(list4) == "string" then
		tinsert(list, list4)
		print = print .. "	Table_4 added as string\n"
	end

	if list5 ~= nil and type(list5) == "table" then
		for y,ing in pairs(list5) do
			tinsert(list, ing)
		end
		print = print .. "	Table_5 added as table\n"
	elseif type(list5) == "string" then
		tinsert(list, list5)
		print = print .. "	Table_5 added as string\n"
	end
	if ezlib.debug_self_self then
		print = print .. "	Returning:\n" .. log_print(list, 0)
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return list
	end,

	string_add = function(string1, string2, string3, string4, string5)
	local string = ""
	local print = "ezlib.string.add\n---------------------------------------------------------------------------------------------\n"
	if type(string1) == "string" then
		string = string .. string1
		print = print .. "	String_1 added as string\n"
	end

	if type(string2) == "string" then
		string = string .. string2
		print = print .. "	String_2 added as string\n"
	end

	if type(string3) == "string" then
		string = string .. string3
	print = print .. "	String_3 added as string\n"
	end

	if type(string4) == "string" then
		string = string .. string4
		print = print .. "	String_4 added as string\n"
	end

	if type(string5) == "string" then
		string = string .. string5
		print = print .. "	String_5 added as string\n"
	end
	if ezlib.debug_self_self then
		print = print .. "	Returning:\n			" .. string
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return string
end
})