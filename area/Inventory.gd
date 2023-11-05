extends RefCounted
class_name Inventory

var items:Array[InventoryItem] = []

func addItem(item:InventoryItem):
	items.push_front(item)

## Returns true if the item was deleted from the inventory, or false if it wasn't there to begin with
func removeItem(item:InventoryItem) -> bool:
	var idx = items.find(item)
	if idx >= 0:
		items.remove_at(idx)
		return true
	else:
		return false
