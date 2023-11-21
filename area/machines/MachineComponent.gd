extends InventoryItem
class_name MachineComponent

func _init():
	super("genericComponent")

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

func generateOverrideProps(_props:Dictionary):
	pass # should override this in subclasses to modify the props dict with generated values

func getDescription():
	return "A nondescript component"
