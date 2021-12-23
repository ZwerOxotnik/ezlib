local tremove = table.remove

function ezlib.entity.get.list(ftype, value)
	local freturn = 0
	local list = {}
	if ftype ~= nil then
		local entities = data.raw[ftype]
		local del_list = {}
		if entities ~= nil then
			for _, prototype in pairs(entities) do
				list[#list+1] = prototype.name
			end
		end
		if value ~= nil and type(value) == "table" and list ~= nil then
			for a in pairs(value) do
				if value[a] ~= nil then
					if type(value[a]) == "string" then
						for x, ing2 in pairs(list) do
							if entities[list[x]][a] ~= value[a] or entities[list[x]][a] == nil then
								del_list[#del_list+1] = ing2
							end
						end
					elseif type(value[a]) == "table" then
						for b,_ in pairs(value[a]) do
							if type(value[a][b]) == "string" then
								for x, ing2 in pairs(list) do
									-- Does this work?
									if entities[list[x]][a][b] ~= value[a][b]  or entities[list[x]][a][b] == nil then
										del_list[#del_list+1] = ing2
									end
								end
							elseif type(value[a][b]) == "table" then
								log("You can't mine so deap")
							else
								break
							end
						end
					else
						break
					end
				end
			end
			list = ezlib.tbl.remove(list, del_list)
		end
		if list then
			if #list == 1 then
				list = list[1]
				freturn = 1
			elseif #list == 0 then
				list = nil
			else
				freturn = 1
			end
		end
	end
	if ezlib.debug_self then
		local print = ""
		print = print .. "ezlib.entity.get.list\n---------------------------------------------------------------------------------------------\n"
		if ftype == nil then
			lprint = print .. "  Type is empty"
		else
			if type(list) == "table" then
				print = print .. "  Found " .. #list .. " entities in type " .. ftype .. "."
			elseif type(list) == "string" then
				print = print .. "  Found entity " .. list .. " in type " .. ftype .. "."
			else
				print = print .. "  [Warning] Found 0 entities in type " .. ftype .. "."
			end
			if type(value) == "table" then
				print = print .. "\n  List of filters:"
				print = print .. ezlib.log.print(value, 0)
			end
		end
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	if freturn == 0 then 
		return nil
	else
		return list
	end
end

function ezlib.entity.add.flag(value, type, flag)
	local print = "ezlib.entity.add.flag\n---------------------------------------------------------------------------------------------\n"
	local entity = data.raw[type][value]
	if entity then
		local flags = entity.flags
		if flags then
			flags[#flags+1] = flag
		else
			entity.flags = flag
		end
		if ezlib.debug_self then
			log(print .. "  Flag " .. flag .. " added to " .. value .. ".\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Entity with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Entity with name " .. value .. " not found.")
		end
	end
end

function ezlib.entity.remove.flag(value, type, flag)
	local print = "ezlib.entity.remove.flag\n---------------------------------------------------------------------------------------------\n"
	local entity = data.raw[type][value]
	if entity then
		local flags = entity.flags
		if flags then
			for i=#flags, 1, -1 do
				-- TODO: check
				if flags[i] == flag then
					tremove(flags, i)
				end
			end
		end
		if ezlib.debug_self then
			log(print .. "  Flag " .. flag .. " removed from " .. value .. ".\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Entity with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Entity with name " .. value .. " not found.")
		end
	end
end
