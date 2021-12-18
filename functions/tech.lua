local tremove = table.remove
local tinsert = table.insert
local technologies = data.raw.technology

function ezlib.tech.add.unlock_recipe (value, frecipe)
	local print = "ezlib.tech.add.unlock_recipe\n---------------------------------------------------------------------------------------------\n"
	local technology = technologies[value]
	if technology then
		tinsert(technology.effects, {type = "unlock-recipe", recipe = frecipe})
		if ezlib.debug_self then
			log(print .. "  Recipe " .. frecipe .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.add.unlock_modifer(value, ftype, fmodifier, fammo_category)
	local print = "ezlib.tech.add.unlock_modifer\n---------------------------------------------------------------------------------------------\n"
	local technology = technologies[value]
	if technology then -- TODO: check
		if ftype == "ammo-damage" or ftype == "gun-speed" then
			tinsert(technology.effects, {type = ftype, ammo_category = fammo_category, modifier = fmodifier})
			if ezlib.debug_self then
				log(print .. "  Effect " .. ftype .. " with modifier " .. fmodifier .. " for ammo category " .. fammo_category .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
			end
		else
			tinsert(technology.effects, {type = ftype, modifier = fmodifier})
			if ezlib.debug_self then
				log(print .. "  Effect " .. ftype .. " with modifier " .. fmodifier .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
			end
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.add.prerequisites (value, ftech)
	local print = "ezlib.tech.add.prerequisites\n---------------------------------------------------------------------------------------------\n"
	local technology = technologies[value]
	if technology and technologies[ftech] then
		tinsert(technology.prerequisites, ftech)
		if ezlib.debug_self then
			log(print .. "  Prerequisites " .. ftech .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Technology with name " .. value .. " or " .. ftech .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " or " .. ftech .. " not found")
		end
	end
end


function ezlib.tech.find.unlock_recipe(value)
	local techs = technologies -- TODO: refactor
	local list = {}
	for _, tech in pairs(techs) do
		if tech.effects ~= nil then
			for _, effect in ipairs(tech.effects) do
				if effect.type == "unlock-recipe" then
					if effect.recipe == value then
						list[#list+1] = techs.name
					end
				end
			end
		end
	end
	local print = "ezlib.tech.find.unlock_recipe\n---------------------------------------------------------------------------------------------\n"
	if #list == 1 then
		list = list[1]
		print = print .. "  Found 1 technologies.\n"
		print = print .. "\n  Renurning: " .. list
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 technologies."
	else
		print = print .. "  Found " .. #list .. " technologies."
	end
	if ezlib.debug_self then
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return list
end

function ezlib.tech.find.unlock_modifer(value, fmodifier)
	local print = "ezlib.tech.find.unlock_modifer\n---------------------------------------------------------------------------------------------\n"
	local techs = technologies -- TODO: refactor
	local list = {}
	for _, tech in pairs(techs) do
		if tech.effects ~= nil then
			for _, effect in ipairs(tech.effects) do
				if effect.type == value then
					if effect.modifier == fmodifier or fmodifier == nil then
						list[#list+1] = tech.name
					end
				end
			end
		end
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found " .. #list .. " technologies.\n"
		print = print .. "\n  Renurning: " .. list
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 technologies."
	else
		print = print .. "  Found " .. #list .. " technologies.\n"
	end
	if ezlib.debug_self then
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return list
end


function ezlib.tech.remove.unlock_recipe (value, frecipe)
	local print = "ezlib.tech.remove.unlock_recipe\n---------------------------------------------------------------------------------------------"
	local technology = technologies[value]
	if technology then
		for y, effect in ipairs(technology.effects) do
			if effect.type == "unlock-recipe" then
				if effect.recipe == frecipe then
					tremove(technology.effects, y)
					print = print .. "\n  Recipe " .. frecipe .. " removed from technology " .. value
				end
			end
		end
		if ezlib.debug_self then
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.remove.unlock_modifer(value, ftype, fammo_category)
	local print = "ezlib.tech.remove.unlock_modifer\n---------------------------------------------------------------------------------------------\n"
	local technology = technologies[value]
	if technology then
		local effects = technology.effects
		for y in ipairs(effects) do -- TODO: check this
			if fammo_category ~= nil then
				if effects.ammo_category == fammo_category and effects.type == ftype then
					tremove(effects, y)
					print = print .. "\n  Effect " .. ftype .. " removed from technology " .. value
				end
			else
				if effects.type == ftype then
					tremove(effects, y)
					print = print .. "\n  Effect " .. ftype .. " removed from technology " .. value
				end
			end
		end
		if ezlib.debug_self then
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.remove.prerequisites(value, ftech)
	local print = "ezlib.tech.remove.prerequisites\n---------------------------------------------------------------------------------------------\n"
	local technology = technologies[value]
	if technology and technologies[ftech] then
		local prerequisites = technology.prerequisites
		for y, prerequisity in ipairs(prerequisites) do
			if prerequisity == ftech then
				tremove(prerequisites, y)
				print = print .. "\n  Prerequisites " .. ftech .. " removed from technology " .. value
			end
		end
		if ezlib.debug_self then
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Technology with name " .. value .. " or " .. ftech .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " or " .. ftech .. " not found")
		end
	end
end

function ezlib.tech.get.list(value)
	local freturn = 0
	local techs = technologies -- TODO: refactor
	local del_list = {}
	local list = {}
	for _, tech in pairs(techs) do
		list[#list+1] = tech.name
	end
	if value ~= nil and type(value) == "table" then
		for a,ing in pairs(value) do
			if value[a] ~= nil then
				if type(ing) == "string" then
					for x,ing2 in ipairs(list) do
						local v = techs[list[x]][a]
						if v ~= ing or v == nil then
							del_list[#del_list+1] = ing2
						end
					end
				elseif type(ing) == "table" then
					for b in pairs(ing) do
						if type(ing[b]) == "string" then
							-- TODO: check x etc
							for x,ing2 in ipairs(list) do
								local v = techs[list[x]][a][b]
								if v ~= ing[b] or v == nil then
									del_list[#del_list+1] = ing2
								end
							end
						elseif type(ing[b]) == "table" then
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
		print = print .. "ezlib.tech.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			print = print .. "  Found " .. #list .. " technologies."
		elseif type(list) == "string" then
			print = print .. "  Found technology " .. list .. "."
		else
			print = print .. "  [Warning] Found 0 technologies in type."
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