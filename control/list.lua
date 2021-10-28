ezlib = {}
ezlib.debug = settings.startup["ez-debug"].value
local list1 = {"item", "entity", "recipe", "tech", "log", "string", "hidden", "tbl"}
local list2 = {"add", "replace", "remove", "find", "get"}
for x,ing in pairs(list1) do
	if not ezlib[ing] then
		ezlib[ing] = {}
	end
	for y,ing2 in pairs(list2) do
		if not ezlib[ing][ing2] then
			ezlib[ing][ing2] = {}
		end
	end
end
ezlib.item.not_item = {"gun", "mining-tool", "tool", "selection-tool", "blueprint", "blueprint-book", "deconstruction-item", "item-with-entity-data", "rail-planner", "item", "capsule", "module", "ammo", "armor", "repair-tool"}
