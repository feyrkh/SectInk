extends OptionButton
class_name TinkerPanelComponent

func configure(cmp:MachineComponentOption, inventory:Inventory, machine:BigMachine):
	var items:Array[InventoryItem] = inventory.items.filter(func(item): return cmp.isValidComponent(item))
	if cmp.attachedComponent != null:
		items.push_front(cmp.attachedComponent)
	clear()
	add_item("-none-")
	set_item_metadata(0, null)
	var idx = 1
	for item in items:
		add_item(item.catalogueId)
		set_item_metadata(idx, item)
		idx += 1
	if cmp.attachedComponent != null:
		select(1)
	else:
		select(0)
	
