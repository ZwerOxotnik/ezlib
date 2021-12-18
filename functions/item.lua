local tremove = table.remove

function ezlib.item.get.list(value)
	if type(value) == "table" then
		if value.not_items then
			not_items = ezlib.item.not_item
			value.not_items = nil
		else
			not_items = "item"
		end
	else
		not_items = "item"
	end
	local freturn = 0
	local item = {}
	local list = {}
	local del_list = {}
	if type(not_items) == "table" then
		for _, ing in ipairs(not_items) do
			local entities = data.raw[ing]
			if entities then
				for b in pairs(entities) do
					local entity = entities[b]
					if entity then
						list[#list+1] = {entity.name, entity.type}
					end
				end
			end
		end
		if value ~= nil and type(value) == "table" then
			for _,ing in ipairs(list) do
				local entity = data.raw[ing[2]][ing[1]]
				for a in pairs(value) do
					local t = value[a] -- ?
					if value[a] ~= nil then
						if type(t) == "string" or type(t) == "number" then
							if entity[a] ~= t or entity[a] == nil then
								del_list[#del_list+1] = ing
							end
						elseif type(t) == "table" then
							for b, v in pairs(t) do
								if type(v) == "string" or type(v) == "number" then
									local r = entity[a][b] -- ?
									if r ~= t[b] or r == nil then
										del_list[#del_list+1] = ing
									end
								elseif type(v) == "table" then
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
			end
		end
	else
		item = data.raw.item -- TODO: refactor
		if item ~= nil then
			for k in pairs(item) do
				list[#list+1] = item[k].name
			end
		end
		if value ~= nil and type(value) == "table" then
			for a in pairs(value) do
				if value[a] ~= nil then
					if type(value[a]) == "string" or type(value[a]) == "number" then
						for x,ing2 in ipairs(list) do
							local v = item[list[x]][a]
							if v ~= value[a] or v == nil then
								del_list[#del_list+1] = ing2
							end
						end
					elseif type(value[a]) == "table" then
						for b in pairs(value[a]) do
							if type(value[a][b]) == "string" or type(value[a][b]) == "number" then
								for x,ing2 in ipairs(list) do
									-- Does this work?
									local v = item[list[x]][a]
									if v ~= value[a][b] or v == nil then
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
		end
	end
	list = ezlib.tbl.remove(list, del_list)
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
	if ezlib.debug_self then
		local print = ""
		print = print .. "ezlib.item.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			print = print .. "  Found " .. #list .. " items."
		elseif type(list) == "string" then
			print = print .. "  Found item " .. list .. "."
		else
			print = print .. "  [Warning] Found 0 items in type."
		end
		if type(value) == "table" then
			print = print .. "\n  List of filters:"
			print = print .. ezlib.log.print(value, 0)
		end
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	if freturn == 0 then
		return nil
	else
		return list
	end
end

function ezlib.item.add.flag(value, flag)
	local print = "ezlib.item.add.flag\n---------------------------------------------------------------------------------------------\n"
	local entity = data.raw.item[value]
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
			log(print .. "  [Warning] Item with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Item with name " .. value .. " not found.")
		end
	end
end

function ezlib.item.remove.flag(value, flag)
	local print = "ezlib.item.remove.flag\n---------------------------------------------------------------------------------------------\n"
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
			log(print .. "  [Warning] Item with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Item with name " .. value .. " not found.")
		end
	end
end
