ezlib = {}
ezlib.debug_self = settings.startup["ez-debug"].value
ezlib.debug = settings.startup["ez-debug_other_mods"].value
local list1 = {"item", "entity", "recipe", "tech", "log", "string", "hidden", "tbl"}
local list2 = {"add", "replace", "remove", "find", "get"}
for _,ing in pairs(list1) do
	if not ezlib[ing] then
		ezlib[ing] = {}
	end
	local ings = ezlib[ing]
	for _,ing2 in pairs(list2) do
		if not ings[ing2] then
			ings[ing2] = {}
		end
	end
end
ezlib.item.not_item = {"gun", "mining-tool", "tool", "selection-tool", "item-with-tags", "item-with-label", "item-with-inventory", "blueprint", "blueprint-book", "deconstruction-item", "item-with-entity-data", "rail-planner", "item", "capsule", "module", "ammo", "armor", "repair-tool", "spidertron-remote"}
