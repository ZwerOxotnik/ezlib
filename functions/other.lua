local tremove = table.remove

function ezlib.log.print(tbl, indent)
	local freturn = 1
	if not indent then
		indent = 0
		freturn = 0
	end
	local toprint = --[["\n" .. string.rep("	", indent) .. ]]"{\r\n"
	indent = indent + 1
	if type(tbl) == "table" then
		for k,v in pairs(tbl) do
			toprint = toprint .. string.rep("	", indent)
			if (type(k) == "number") then
				toprint = toprint .. "[" .. k .. "] = "
			elseif (type(k) == "string") then
				toprint = toprint .. k .. " = "
			end
			if (type(v) == "number") then
				toprint = toprint .. v .. ",\r\n"
			elseif (type(v) == "string") then
				toprint = toprint .. '"' .. v .. '",\r\n'
			elseif (type(v) == "table") then
				local counter = 0
				for _,_ in pairs(v) do
					counter = counter + 1
				end
				if counter == 0 then
					toprint = toprint .. "{ },\r\n"
				else
					toprint = toprint .. ezlib.log.print(v, indent) .. ",\r\n"
				end
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

function ezlib.tbl.remove(list1, list2)
	local print = "ezlib.tbl.remove\n---------------------------------------------------------------------------------------------\n"
	if list1 ~= nil then
		if list2 ~= nil then
			local list3 = {}
			for _, ing in pairs(list1) do
				list3[#list3+1] = ing
			end
			local z = 0
			for x, ing in pairs(list1) do
				if type(list2) == "table" then
					for _,ing2 in pairs(list2) do
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
				print = print .. "  Removed ".. (#list1 - #list3) .. " items.\n"
			else
				print = print .. "  Removed string ".. list2 .. ".\n"
			end
			if ezlib.debug_self then
				log(print .. "  \n---------------------------------------------------------------------------------------------")
			end
			return list3
		else
		if ezlib.debug_self then
			print = print .. "  list2 is empty."
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
			return list1
		end
	else
		if ezlib.debug_self then
			print = print .. "  list1 is empty. Returning: nil"
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
		return nil
	end
end

function ezlib.tbl.add(list1, list2, list3, list4, list5)
	local list = {}
	local print = "ezlib.tbl.add\n---------------------------------------------------------------------------------------------\n"
	if type(list1) == "table" then
		for _,ing in pairs(list1) do
			list[#list+1] = ing
		end
		print = print .. "  Table_1 added as table\n"
	elseif type(list1) == "string" then
		list[#list+1] = list1
		print = print .. "  Table_1 added as string\n"
	end

	if type(list2) == "table" then
		for _,ing in pairs(list2) do
			list[#list+1] = ing
		end
		print = print .. "  Table_2 added as table\n"
	elseif type(list2) == "string" then
		list[#list+1] = list2
		print = print .. "  Table_2 added as string\n"
	end

	if type(list3) == "table" then
		for _,ing in pairs(list3) do
			list[#list+1] = ing
		end
		print = print .. "  Table_3 added as table\n"
	elseif type(list3) == "string" then
		list[#list+1] = list3
		print = print .. "  Table_3 added as string\n"
	end

	if type(list4) == "table" then
		for _,ing in pairs(list4) do
			list[#list+1] = ing
		end
		print = print .. "  Table_4 added as table\n"
	elseif type(list4) == "string" then
		list[#list+1] = list4
		print = print .. "  Table_4 added as string\n"
	end

	if type(list5) == "table" then
		for _,ing in pairs(list5) do
			list[#list+1] = ing
		end
		print = print .. "  Table_5 added as table\n"
	elseif type(list5) == "string" then
		list[#list+1] = list5
		print = print .. "  Table_5 added as string\n"
	end
	if ezlib.debug_self then
		log(print .. "---------------------------------------------------------------------------------------------")
	end
	return list
end

function ezlib.string.add(string1, string2, string3, string4, string5)
	local string = ""
	local print = "ezlib.string.add\n---------------------------------------------------------------------------------------------\n"
	if type(string1) == "string" then
		string = string .. string1
	end

	if type(string2) == "string" then
		string = string .. string2
	end

	if type(string3) == "string" then
		string = string .. string3
	end

	if type(string4) == "string" then
		string = string .. string4
	end

	if type(string5) == "string" then
		string = string .. string5
	end
	if ezlib.debug_self then
		print = print .. "  Returning: " .. string
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return string
end

function ezlib.remove(ftype, value)
	local entites = data.raw[ftype]
	if entites and entites[value] then
		local entity = entites[value]
		if not entity.icon and not entity.icons then
			log(entity.icon)
			entity.icon = "__core__/graphics/slot-icon-blueprint.png"
			log("  [Warning] " .. ftype .. " with name " .. value .. " has no icon adding...")
			entity.localised_description = "Icon not found"
		end
		if not entity.icon_size then
			entity.icon_size = 32
			log("  [Warning] " .. ftype .. " with name " .. value .. " has no icon_size adding...")
		end
	end
end