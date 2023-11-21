extends InventoryItemOption
class_name MachineComponentOption

var effectsModified:Array[String] = []
# prop name -> expected value
var propIdealValues:Dictionary = {}

func _init(name:String, effectsModified:Array[String], propIdealValues:Dictionary):
	super(name, propIdealValues.keys())
	self.requireType = RequireType.ALL
	self.effectsModified = effectsModified
	self.propIdealValues = propIdealValues
