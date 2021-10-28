local tremove = table.remove

function ezlib.recipe.remove.ingredient (value, target_ingredient)
	local print = "ezlib.recipe.remove.ingredient\n---------------------------------------------------------------------------------------------\n"
	local original_recipe = data.raw.recipe[value]
	local new_recipe = table.deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			local ingredients_normal = new_recipe.normal.ingredients
			for i=1, #ingredients_normal do
				local ingredient = ingredients_normal[i]
				if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
					--ingredients_expensive[i] = nil
					tremove(ingredients_normal, i)
					print = print .. "Removed " .. target_ingredient .. " from recipe " .. value .. " (difficulty normal).\n"
				end
			end
			original_recipe.normal.ingredients = ingredients_normal
			local ingredients_expensive = new_recipe.expensive.ingredients
			for i=1, #ingredients_expensive do
				local ingredient = ingredients_expensive[i]
				if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
					--ingredients_expensive[i] = nil
					tremove(ingredients_expensive, i)
					print = print .. "Removed " .. target_ingredient .. " from recipe " .. value .. " (difficulty expensive).\n"
				end
			end
			original_recipe.expensive.ingredients = ingredients_normal
		else
			local ingredients = new_recipe.ingredients
			for i=1, #ingredients do
				local ingredient = ingredients[i]
				if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
					--ingredients[i] = nil
					tremove(ingredients, i)
					print = print .. "  Removed " .. target_ingredient .. " from recipe " .. value .. " (no difficulty).\n"
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
			log(print .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found.")
		end
	end
end

function ezlib.recipe.add.ingredient(value, fingredient, famount, ftype)
	local print = "ezlib.recipe.add.ingredient\n---------------------------------------------------------------------------------------------\n"
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
		print = print .. "  Type is fluid\n"
	else
		ftype = "item"
		print = print .. "  Type is item\n"
	end
	local original_recipe = data.raw.recipe[value]
	new_recipe = table.deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			table.insert(new_recipe.normal.ingredients, {type=ftype, name=fingredient, amount=famount})
			table.insert(new_recipe.expensive.ingredients, {type=ftype, name=fingredient, amount=famount})
			original_recipe.normal.ingredients = new_recipe.normal.ingredients
			original_recipe.expensive.ingredients = new_recipe.expensive.ingredients
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. "(normal and expensive).\n"
		else
			table.insert(new_recipe.ingredients, {type=ftype, name=fingredient, amount=famount})
			original_recipe.ingredients = new_recipe.ingredients
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. ".\n"
		end
	else
		print = print .. "  [Warning] Recipe with name " .. value .. " not found\n"
		if not ezlib.debug_self then
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
	log(print .. "---------------------------------------------------------------------------------------------")
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
	local print = "ezlib.recipe.get.ingredient\n---------------------------------------------------------------------------------------------\n"
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
	local recipe = {}
	local out = {}
	recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if difficulty == 0 then
			print = print .. "  Difficulty normal\n"
		else
			print = print .. "  Difficulty expensive (if possible)\n"
		end
		if fingredient == 1 then
			print = print .. "  No filter by ingredient\n"
		else
			print = print .. "  Ingredient filter active\n"
		end
		if ftype == 1 then
			print = print .. "  Filter by item\n"
		elseif ftype == 2 then
			print = print .. "  Filter by fluid\n"
		else
			print = print .. "  No filter by type\n"
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
						log(print .. "  Renurning true\n---------------------------------------------------------------------------------------------")
					end
					return true
				end
			end
			if ezlib.debug_self then
				log(print .. "  Renurning false\n---------------------------------------------------------------------------------------------")
			end
			return false
		else
			if ezlib.debug_self then
				log(print .. "  Renurning:" .. ezlib.log.print(out, 0) .. "\n---------------------------------------------------------------------------------------------")
			end
			return out
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end


function ezlib.recipe.remove.result(value, target_ingredient)
	local print = "ezlib.recipe.remove.result\n---------------------------------------------------------------------------------------------\n"
	local original_recipe = data.raw.recipe[value]
	local new_recipe = table.deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			if new_recipe.normal.result ~= nil then
				if new_recipe.normal.result == target_ingredient then
					original_recipe.normal.result = nil
					print = print .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Normal)\n"
				end
				if new_recipe.expensive.result == target_ingredient then
					original_recipe.expensive.result = nil
					print = print .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Expensive)\n"
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
				data.raw.recipe[value].normal.results = results_normal
				print = print .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Normal)\n"
				local results_expensive = new_recipe.expensive.ingredients
				for i=1, #results_expensive do
					local ingredient = results_expensive[i]
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients_expensive[x] = nil
						tremove(results_expensive, i)
					end
				end
				data.raw.recipe[value].expensive.results = results_expensive
				print = print .. "  " .. target_ingredient .. "Removed from " .. value .. ".(Expensive)\n"
			end
		else
			if new_recipe.result == target_ingredient then
				data.raw.recipe[value].result = nil
				print = print .. "  " .. target_ingredient .. "Removed from " .. value .. ".\n"
			else
				local results = new_recipe.results
				for i=1, #results do
					local ingredient = results[i]
					if ingredient[1] == target_ingredient or ingredient["name"] == target_ingredient then
						--ingredients[x] = nil
						tremove(results, i)
					end
				end
				data.raw.recipe[value].results = results
				print = print .. "  " .. target_ingredient .. "Removed from " .. value .. ".\n"
			end
		end
		if ezlib.debug_self then
			log(print .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end

function ezlib.recipe.add.result (value, fingredient, famount, ftype)
	local print = "ezlib.recipe.add.result\n---------------------------------------------------------------------------------------------\n"
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
		print = print .. "  Type is fluid\n"
	else
		ftype = "item"
		print = print .. "  Type is item\n"
	end
	local original_item = data.raw.item[value]
	local original_recipe = data.raw.recipe[value]
	local new_recipe = table.deepcopy(original_recipe)
	if new_recipe ~= nil then
		if new_recipe.normal ~= nil then
			if new_recipe.normal.results == nil then
				print = print .. "  Recipe " .. value .. " have no results... adding\n"
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
					table.insert(new_recipe.normal.results, {type="item", name=new_recipe.normal.result, amount=new_recipe.normal.result_count or 1})
				end
				if new_recipe.expensive.result ~= nil then
					table.insert(new_recipe.expensive.results, {type="item", name=new_recipe.expensive.result, amount=new_recipe.expensive.result_count or 1})
				end
			end
			table.insert(new_recipe.normal.results, {type=ftype, name=fingredient, amount=famount})
			table.insert(new_recipe.expensive.results, {type=ftype, name=fingredient, amount=famount})
			original_recipe.normal.results = new_recipe.normal.results
			original_recipe.expensive.results = new_recipe.expensive.results
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. "(normal and expensive).\n"
		else
			if new_recipe.results == nil then
				new_recipe.results = {}
				original_recipe.result = nil
				original_recipe.icon = original_item.icon
				original_recipe.icon_size = original_item.icon_size
				original_recipe.subgroup = original_item.subgroup
				if new_recipe.result ~= nil then
					print = print .. "  Recipe " .. value .. " have no results... adding\n"
					table.insert(new_recipe.results, {type="item", name=new_recipe.result, amount=new_recipe.result_count or 1})
				end
			end
			if new_recipe.category == nil and ftype == "fluid" then original_recipe.category = "crafting-with-fluid" end
			table.insert(new_recipe.results, {type=ftype, name=fingredient, amount=famount})
			original_recipe.results = new_recipe.results
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. ".\n"
		end
		if ezlib.debug_self then
			log(print .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug_self then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
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
	local print = "ezlib.recipe.get.result\n---------------------------------------------------------------------------------------------\n"
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
	recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if difficulty == 0 then
			print = print .. "  Difficulty normal\n"
		else
			print = print .. "  Difficulty expensive (if possible)\n"
		end
		if fingredient == 1 then
			print = print .. "  No filter by ingredient\n"
		else
			print = print .. "  Ingredient filter active\n"
		end
		if ftype == 1 then
			print = print .. "  Filter by item\n"
		elseif ftype == 2 then
			print = print .. "  Filter by fluid\n"
		else
			print = print .. "  No filter by type\n"
		end
		print = print .. value
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
						log(print .. "  Renurning false\n---------------------------------------------------------------------------------------------")
					end
					return true
				end
			end
			if ezlib.debug_self then
				log(print .. "  Renurning false\n---------------------------------------------------------------------------------------------")
			end
			return false
		else
			if ezlib.debug_self then
				log(print .. "  Renurning:" .. ezlib.log.print(out, 0) .. "\n---------------------------------------------------------------------------------------------")
			end
			return out
		end
	else
		log("  [Warning] Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.find.ingredient (value)
	local print = "ezlib.recipe.find.ingredient\n---------------------------------------------------------------------------------------------\n"
	local recipe = data.raw.recipe
	local list = {}
	for x,ing in pairs(recipe) do
		if ezlib.recipe.ingredient.get({recipe_name = recipe[x].name, ingredient = value}) then
			table.insert(list, recipe[x].name)
		end
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found " .. #list .. " recipes.\n"
		print = print .. "\n  Renurning:"
		print = print .. ezlib.log.print(list, 0)
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 recipes."
	else
		print = print .. "  Found " .. #list .. " recipes.\n"
		print = print .. "\n  Renurning:" .. list
	end
	log(print .. "\n---------------------------------------------------------------------------------------------")
	return list
end

function ezlib.recipe.find.result (value)
	local print = "ezlib.recipe.find.result\n---------------------------------------------------------------------------------------------\n"
	local recipes = data.raw.recipe -- TODO: refactor
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
	local recipe = data.raw.recipe -- TODO: refactor
	local list = {}
	local del_list = {}
	if recipe ~= nil then
		for _, _recipe in pairs(recipe) do
			list[#list+1] = _recipe.name
		end
	end
	if value ~= nil and type(value) == "table" then
		for a, ing in pairs(value) do
			if ing ~= nil then
				if type(ing) == "string" then
					for x,ing2 in ipairs(list) do
						if recipe[list[x]][a] ~= ing or recipe[list[x]][a] == nil then
							table.insert(del_list, ing2)
						end
					end
				elseif type(ing) == "table" then
					local entities = ing
					for b in pairs(entities) do
						local entity = entities[b]
						if type(entity) == "string" then
							for i,ing2 in ipairs(list) do
								-- TODO: check
								local v = recipe[list[i]][a][b]
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
		local print = ""
		print = print .. "ezlib.recipes.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			print = print .. "  Found " .. #list .. " recipes."
		elseif type(list) == "string" then
			print = print .. "  Found recipe " .. list .. "."
		else
			print = print .. "  [Warning] Found 0 recipes in type."
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
