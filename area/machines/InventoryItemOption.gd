extends MachineOption
class_name InventoryItemOption

enum RequireType {ALL, ANY}

var requiredProps:Array
var requireType:RequireType = RequireType.ANY
var attachedItem:InventoryItem = null

func _init(name:String, requiredProps:Array):
	super(name)
	self.requiredProps = requiredProps

func filterInventoryItems(items:Array[InventoryItem]) -> Array[InventoryItem]:
	return items.filter(itemMatchesRequirements)

func itemMatchesRequirements(item:InventoryItem) -> bool:
	if requireType == RequireType.ANY:
		for prop in requiredProps:
			if item.getProp(prop) != null:
				return true
		return false
	else:
		for prop in requiredProps:
			if item.getProp(prop) == null:
				return false
		return true

## Returns an array of inventory items in the format [oldItem, newItem] - one or both of these may be null
func swapComponents(newItem:InventoryItem, sourceInventory:Inventory) -> Array[InventoryItem]:
	var itemFoundInSource:bool = true # default to true, because the item might be null
	var oldComponent:InventoryItem = attachedItem
	if newItem != null:
		itemFoundInSource = sourceInventory.removeItem(newItem)
	if attachedItem != null:
		sourceInventory.addItem(attachedItem)
	if itemFoundInSource:
		attachedItem = newItem
	return [oldComponent, attachedItem]
