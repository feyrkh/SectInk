extends MachineOption
class_name MachineComponentOption

var effectsModified:Array[String] = []
# prop name -> expected value
var propIdealValues:Dictionary = {}
var attachedComponent:MachineComponent = null

func _init(name:String, effectsModified:Array[String], propIdealValues:Dictionary):
	super(name)
	self.effectsModified = effectsModified
	self.propIdealValues = propIdealValues
		
func isValidComponent(item:InventoryItem):
	if !item.has_method("getProp"):
		return false
	for prop in propIdealValues:
		if item.getProp(prop) == null:
			return false
	return true

## Returns false if the item we're attaching couldn't be found in its supposed source inventory
func swapComponents(newComponent:MachineComponent, sourceInventory:Inventory) -> bool:
	var itemFoundInSource:bool = true # default to true, because the item might be null
	if newComponent != null:
		itemFoundInSource = sourceInventory.removeItem(newComponent)
	if attachedComponent != null:
		sourceInventory.addItem(attachedComponent)
	if itemFoundInSource:
		attachedComponent = newComponent
		return true
	else:
		return false
