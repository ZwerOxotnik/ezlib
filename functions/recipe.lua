local tremove = table.remove
local tinsert = table.insert
local deepcopy = table.deepcopy
local recipes = data.raw.recipe

function ezlib.recipe.remove.ingredient (value, target_ingredient)
	local message = "ezlib.recipe.remove.ingredient\n---------------------------------------------------------------------------------------------\n"
	local original_recipe = recipes[value]
	local new_recipe = deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			local ingredients_normal = new_recipe.normal.ingredients
			for i=#ingredients_normal, 1, -1 do
				local ingredient = ingredients_normal[i]
				if ingredient then
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients_expensive[i] = nil
						tremove(ingredients_normal, i)
						message = message .. "Removed " .. target_ingredient .. " from recipe " .. value .. " (difficulty normal).\n"
					end
				else
					tremove(ingredients_normal, i)
				end
			end
			original_recipe.normal.ingredients = ingredients_normal
			local ingredients_expensive = new_recipe.expensive.ingredients
			for i=#ingredients_expensive, 1, -1 do
				local ingredient = ingredients_expensive[i]
				if ingredient then
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients_expensive[i] = nil
						tremove(ingredients_expensive, i)
						message = message .. "Removed " .. target_ingredient .. " from recipe " .. value .. " (difficulty expensive).\n"
					end
				else
					tremove(ingredient, i)
				end
			end
			original_recipe.expensive.ingredients = ingredients_normal
		else
			local ingredients = new_recipe.ingredients
			for i=#ingredients, 1, -1 do
				local ingredient = ingredients[i]
				if ingredient then
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients[i] = nil
						tremove(ingredients, i)
						message = message .. "  Removed " .. target_ingredient .. " from recipe " .. value .. " (no difficulty).\n"
					end
				else
					tremove(ingredient, i)
				end
			end
			original_recipe.ingredients = ingredients
		end
		if not new_recipe.normal then new_recipe.normal = {} end if not new_recipe.expensive then new_recipe.expensive = {} end
		-- This seems wrong
		-- if new_recipe.normal.ingredients == ingredients_normal and new_recipe.expensive.ingredients == ingredients_expensive and new_recipe.ingredients == ingredients then
		-- 	print = print .. "  [Warning] Ingredient " .. target_ingredient .. " from recipe " .. value .. " wasnt removed.\n"
		-- end
		if ezlib.debug_self then
			log(message .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(message .. "  [Warning] Recipe with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found.")
		end
	end
end

function ezlib.recipe.add.ingredient(value, fingredient, famount, ftype)
	local message = "ezlib.recipe.add.ingredient\n---------------------------------------------------------------------------------------------\n"
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
		message = message .. "  Type is fluid\n"
	else
		ftype = "item"
		message = message .. "  Type is item\n"
	end
	local original_recipe = recipes[value]
	local new_recipe = deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			tinsert(new_recipe.normal.ingredients, {type=ftype, name=fingredient, amount=famount})
			tinsert(new_recipe.expensive.ingredients, {type=ftype, name=fingredient, amount=famount})
			original_recipe.normal.ingredients = new_recipe.normal.ingredients
			original_recipe.expensive.ingredients = new_recipe.expensive.ingredients
			message = message .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. "(normal and expensive).\n"
		else
			tinsert(new_recipe.ingredients, {type=ftype, name=fingredient, amount=famount})
			original_recipe.ingredients = new_recipe.ingredients
			message = message .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. ".\n"
		end
	else
		message = message .. "  [Warning] Recipe with name " .. value .. " not found\n"
		if not ezlib.debug_self then
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
	log(message .. "---------------------------------------------------------------------------------------------")
end

function ezlib.recipe.replace.ingredient (value, ingredient, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	ezlib.recipe.remove.ingredient (value, ingredient)
	ezlib.recipe.add.ingredient (value, fingredient, famount, ftype)
end

function ezlib.recipe.get.ingredient (value)
	local message = "ezlib.recipe.get.ingredient\n---------------------------------------------------------------------------------------------\n"
	local ftype, difficulty, fingredient
	if type(value) ~= "string" then
		if value["type"] == 1 or value["type"] == "item" then
			ftype = 1
		else
			if value["type"] == "fluid" or value["type"] == 2 then
				ftype = 2
			else
				ftype = 0
			end
		end
		if value["ingredient"] ~= nil then
			fingredient = value["ingredient"]
		else
			fingredient = 1
		end
		if value["difficulty"] ~= nil or value["difficulty"] == 0 or value["difficulty"] == "normal" then
			difficulty = 0
		else
			difficulty = 1
		end
		value = value["recipe_name"]
	else
		difficulty = 0
		fingredient = 1
		ftype = 0
	end
	local ingredients = {}
	local out = {}
	local recipe = deepcopy(recipes[value])
	if recipe ~= nil then
		if difficulty == 0 then
			message = message .. "  Difficulty normal\n"
		else
			message = message .. "  Difficulty expensive (if possible)\n"
		end
		if fingredient == 1 then
			message = message .. "  No filter by ingredient\n"
		else
			message = message .. "  Ingredient filter active\n"
		end
		if ftype == 1 then
			message = message .. "  Filter by item\n"
		elseif ftype == 2 then
			message = message .. "  Filter by fluid\n"
		else
			message = message .. "  No filter by type\n"
		end
		if recipe.normal ~= nil then
			if difficulty == 1 or recipe.expensive == nil then
				ingredients = recipe.normal.ingredients
			else
				ingredients = recipe.expensive.ingredients
			end
		else
			ingredients = recipe.ingredients
		end
		if ftype == 0 then
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient["type"] == nil then
					out[#out+1] = {type="item", name=ingredient[1], amount=ingredient[2]}
				else
					out[#out+1] = {type=ingredient["type"], name=ingredient["name"], amount=ingredient["amount"]}
				end
			end
		end
		if ftype == 1 then
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient["type"] == nil then
					out[#out+1] = {type="item", name=ingredient[1], amount=ingredient[2]}
				else
					if ingredient["type"] == "item" then
						out[#out+1] = {type=ingredient["type"], name=ingredient["name"], amount=ingredient["amount"]}
					end
				end
			end
		end
		if ftype == 2 then
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient["type"] == "fluid" then
					out[#out+1] = {type=ingredient["type"], name=ingredient["name"], amount=ingredient["amount"]}
				end
			end
		end
		if fingredient ~= 1 then
			for i=1, #out do
				local ingredient = out[i]
				if ingredient["name"] == fingredient then
					if ezlib.debug_self then
						log(message .. "  Renurning true\n---------------------------------------------------------------------------------------------")
					end
					return true
				end
			end
			if ezlib.debug_self then
				log(message .. "  Renurning false\n---------------------------------------------------------------------------------------------")
			end
			return false
		else
			if ezlib.debug_self then
				log(message .. "  Renurning:" .. ezlib.log.print(out, 0) .. "\n---------------------------------------------------------------------------------------------")
			end
			return out
		end
	else
		if ezlib.debug_self then
			log(message .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end


function ezlib.recipe.remove.result(value, target_ingredient)
	local message = "ezlib.recipe.remove.result\n---------------------------------------------------------------------------------------------\n"
	local original_recipe = recipes[value]
	local new_recipe = deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			if new_recipe.normal.result ~= nil then
				if new_recipe.normal.result == target_ingredient then
					original_recipe.normal.result = nil
					message = message .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Normal)\n"
				end
				if new_recipe.expensive.result == target_ingredient then
					original_recipe.expensive.result = nil
					message = message .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Expensive)\n"
				end
			else
				local results_normal = new_recipe.normal.results
				for i=1, #results_normal do
					local ingredient = results_normal[i]
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients_normal[i] = nil
						tremove(results_normal, i)
					end
				end
				recipes[value].normal.results = results_normal
				message = message .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Normal)\n"
				local results_expensive = new_recipe.expensive.ingredients
				for i=1, #results_expensive do
					local ingredient = results_expensive[i]
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients_expensive[x] = nil
						tremove(results_expensive, i)
					end
				end
				recipes[value].expensive.results = results_expensive
				message = message .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Expensive)\n"
			end
		else
			if new_recipe.result == target_ingredient then
				recipes[value].result = nil
				message = message .. "  " .. target_ingredient .. "Removed from " .. value .. ".\n"
			else
				local results = new_recipe.results
				for i=1, #results do
					local ingredient = results[i]
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients[x] = nil
						tremove(results, i)
					end
				end
				recipes[value].results = results
				message = message .. "  " .. target_ingredient .. "Removed from " .. value .. ".\n"
			end
		end
		if ezlib.debug_self then
			log(message .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(message .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end

function ezlib.recipe.add.result (value, fingredient, famount, ftype)
	local message = "ezlib.recipe.add.result\n---------------------------------------------------------------------------------------------\n"
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
		message = message .. "  Type is fluid\n"
	else
		ftype = "item"
		message = message .. "  Type is item\n"
	end
	local original_item = data.raw.item[value]
	local original_recipe = recipes[value]
	local new_recipe = deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			if new_recipe.normal.results == nil then
				message = message .. "  Recipe " .. value .. " have no results... adding\n"
				new_recipe.normal.results = {}
				new_recipe.expensive.results = {}
				original_recipe.normal.result = nil
				original_recipe.expensive.result = nil
				original_recipe.icon = original_item.icon
				original_recipe.icon_size = original_item.icon_size
				original_recipe.subgroup = original_item.subgroup
				--if recipe.normal.result_count == nil then recipe.normal.result_count = 1 end
				--if recipe.expensive.result_count == nil then recipe.expensive.result_count = 1 end
				if new_recipe.normal.result ~= nil then
					tinsert(new_recipe.normal.results, {type="item", name=new_recipe.normal.result, amount=new_recipe.normal.result_count or 1})
				end
				if new_recipe.expensive.result ~= nil then
					tinsert(new_recipe.expensive.results, {type="item", name=new_recipe.expensive.result, amount=new_recipe.expensive.result_count or 1})
				end
			end
			tinsert(new_recipe.normal.results, {type=ftype, name=fingredient, amount=famount})
			tinsert(new_recipe.expensive.results, {type=ftype, name=fingredient, amount=famount})
			original_recipe.normal.results = new_recipe.normal.results
			original_recipe.expensive.results = new_recipe.expensive.results
			message = message .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. "(normal and expensive).\n"
		else
			if new_recipe.results == nil then
				new_recipe.results = {}
				original_recipe.result = nil
				original_recipe.icon = original_item.icon
				original_recipe.icon_size = original_item.icon_size
				original_recipe.subgroup = original_item.subgroup
				if new_recipe.result ~= nil then
					message = message .. "  Recipe " .. value .. " have no results... adding\n"
					tinsert(new_recipe.results, {type="item", name=new_recipe.result, amount=new_recipe.result_count or 1})
				end
			end
			if new_recipe.category == nil and ftype == "fluid" then original_recipe.category = "crafting-with-fluid" end
			tinsert(new_recipe.results, {type=ftype, name=fingredient, amount=famount})
			original_recipe.results = new_recipe.results
			message = message .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. ".\n"
		end
		if ezlib.debug_self then
			log(message .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(message .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end

function ezlib.recipe.replace.result (value, ingredient, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	ezlib.recipe.remove.result (value, ingredient)
	ezlib.recipe.add.result (value, fingredient, famount, ftype)
end

function ezlib.recipe.get.result (value)
	local message = "ezlib.recipe.get.result\n---------------------------------------------------------------------------------------------\n"
	local ftype, difficulty, fingredient
	if type(value) ~= "string" then
		if value["type"] == 1 or value["type"] == "item" then
			ftype = 1
		else
			if value["type"] ~= nil then
				ftype = 2
			else
				ftype = 0
			end
		end
		if value["ingredient"] ~= nil then
			fingredient = value["ingredient"]
		else
			fingredient = 1
		end
		if value["difficulty"] ~= nil or value["difficulty"] == 0 or value["difficulty"] == "normal" then
			difficulty = 0
		else
			difficulty = 1
		end
		value = value["recipe_name"]
	else
		difficulty = 0
		fingredient = 1
		ftype = 0
	end
	local ingredients = {}
	local recipe = {}
	local out = {}
	recipe = deepcopy(recipes[value])
	if recipe ~= nil then
		if difficulty == 0 then
			message = message .. "  Difficulty normal\n"
		else
			message = message .. "  Difficulty expensive (if possible)\n"
		end
		if fingredient == 1 then
			message = message .. "  No filter by ingredient\n"
		else
			message = message .. "  Ingredient filter active\n"
		end
		if ftype == 1 then
			message = message .. "  Filter by item\n"
		elseif ftype == 2 then
			message = message .. "  Filter by fluid\n"
		else
			message = message .. "  No filter by type\n"
		end
		message = message .. value
		if recipe.normal ~= nil then
			if difficulty == 1 or recipe.expensive == nil then
				if recipe.normal.result ~= nil then
					ingredients[#ingredients+1] = {recipe.normal.result, recipe.normal.result_count or 1}
				else
					ingredients = recipe.normal.results
				end
			else
				if recipe.expensive.result ~= nil then
					ingredients[#ingredients+1] = {recipe.expensive.result, recipe.expensive.result_count or 1}
				else
					ingredients = recipe.expensive.results
				end
			end
		else
			if recipe.result ~= nil then
				ingredients[#ingredients+1] = {recipe.result, recipe.result_count or 1}
			else
				ingredients = recipe.results
			end
		end
		if ftype == 0 then
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient["type"] == nil then
					out[#out+1] = {type="item", name=ingredient[1], amount=ingredient[2]}
				else
					out[#out+1] = {type=ingredient["type"], name=ingredient["name"], amount=ingredient["amount"]}
				end
			end
		end
		if ftype == 1 then
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient["type"] == nil then
					out[#out+1] = {type="item", name=ingredient[1], amount=ingredient[2]}
				else
					if ingredient["type"] == "item" then
						out[#out+1] = {type=ingredient["type"], name=ingredient["name"], amount=ingredient["amount"]}
					end
				end
			end
		end
		if ftype == 2 then
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient["type"] == "fluid" then
					out[#out+1] = {type=ingredient["type"], name=ingredient["name"], amount=ingredient["amount"]}
				end
			end
		end
		if fingredient ~= 1 then
			for _,ing in ipairs(out) do
				if ing["name"] == fingredient then
					if ezlib.debug_self then
						log(message .. "  Renurning false\n---------------------------------------------------------------------------------------------")
					end
					return true
				end
			end
			if ezlib.debug_self then
				log(message .. "  Renurning false\n---------------------------------------------------------------------------------------------")
			end
			return false
		else
			if ezlib.debug_self then
				log(message .. "  Renurning:" .. ezlib.log.print(out, 0) .. "\n---------------------------------------------------------------------------------------------")
			end
			return out
		end
	else
		log("  [Warning] Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.find.ingredient (value)
	local message = "ezlib.recipe.find.ingredient\n---------------------------------------------------------------------------------------------\n"
	local recipe = recipes
	local list = {}
	for x in pairs(recipe) do
		if ezlib.recipe.ingredient.get({recipe_name = recipe[x].name, ingredient = value}) then
			tinsert(list, recipe[x].name)
		end
	end
	if #list == 1 then
		list = list[1]
		message = message .. "  Found " .. #list .. " recipes.\n"
		message = message .. "\n  Renurning:"
		message = message .. ezlib.log.print(list, 0)
	elseif #list == 0 or not list then
		list = nil
		message = message .. "  [Warning] Found 0 recipes."
	else
		message = message .. "  Found " .. #list .. " recipes.\n"
		message = message .. "\n  Renurning:" .. list
	end
	log(message .. "\n---------------------------------------------------------------------------------------------")
	return list
end

function ezlib.recipe.find.result (value)
	local print = "ezlib.recipe.find.result\n---------------------------------------------------------------------------------------------\n"
	local list = {}
	for _,recipe in pairs(recipes) do
		if ezlib.recipe.result.get({recipe_name = recipe.name, ingredient = value}) then
			list[#list+1] = recipe.name
		end
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found " .. #list .. " recipes in type."
		print = print .. "\n  Renurning:"
		print = print .. ezlib.log.print(list, 0)
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 recipes in type."
	else
		print = print .. "  Found " .. #list .. " recipes in type."
		print = print .. "\n  Renurning:" .. list
	end
	log(print .. "\n---------------------------------------------------------------------------------------------")
	return list
end

function ezlib.recipe.get.list (value)
	local freturn = 0
	local list = {}
	local del_list = {}
	if recipes ~= nil then
		for _, recipe in pairs(recipes) do
			list[#list+1] = recipe.name
		end
	end
	if value ~= nil and type(value) == "table" then
		for a, ing in pairs(value) do
			if ing ~= nil then
				if type(ing) == "string" then
					for x,ing2 in ipairs(list) do
						if recipes[list[x]][a] ~= ing or recipes[list[x]][a] == nil then
							tinsert(del_list, ing2)
						end
					end
				elseif type(ing) == "table" then
					local entities = ing
					for b in pairs(entities) do
						local entity = entities[b]
						if type(entity) == "string" then
							for i,ing2 in ipairs(list) do
								-- TODO: check
								local v = recipes[list[i]][a][b]
								if v ~= entity or v == nil then
									del_list[#del_list+1] = ing2
								end
							end
						elseif type(entity) == "table" then
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
		local message = ""
		message = message .. "ezlib.recipes.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			message = message .. "  Found " .. #list .. " recipes."
		elseif type(list) == "string" then
			message = message .. "  Found recipe " .. list .. "."
		else
			message = message .. "  [Warning] Found 0 recipes in type."
		end
		if type(value) == "table" then
			message = message .. "\n  List of filters:"
			message = message .. ezlib.log.print(value, 0)
		end
		log(message .. "\n---------------------------------------------------------------------------------------------")
	end
	if freturn == 0 then
		return nil
	else
		return list
	end
end
