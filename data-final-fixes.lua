local items = ezlib.item.get.list()
for x,y in ipairs(items) do
	ezlib.remove("item", y)
end
