extends InventoryItem
class_name MachineComponent

var props:Dictionary = {}

func postConstruct():
	configure(typeName, variantId, itemNumber, tier, props)

func configure(typeName:String, variantId:int, itemNumber:int, tier:int, props:Dictionary) -> MachineComponent:
	self.typeName = typeName
	typeId = CatalogueMgr.getTypeIdForName(typeName)
	self.variantId = variantId
	self.itemNumber = itemNumber
	self.tier = tier
	self.props = props
	generateOverrideProps(props)
	catalogueId = CatalogueMgr.getCatalogueId(typeId, variantId, itemNumber)
	return self

func generateOverrideProps(props:Dictionary):
	pass # should override this in subclasses to modify the props dict with generated values

func setProp(k:String, val):
	props[k] = val

func getProp(k:String, default=null):
	return props.get(k, default)

func getDescription():
	return "A nondescript component"
