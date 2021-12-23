local items = ezlib.item.get.list()
for _, v in pairs(items) do
	ezlib.remove("item", v)
end
