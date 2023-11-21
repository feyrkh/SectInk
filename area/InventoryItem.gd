extends Resource
class_name InventoryItem

static var _nextRandomNumber:int = 0

var props:Dictionary = {}

var typeName:String:
	get:
		return CatalogueMgr.getTypeName(typeId)
	set(val):
		typeId = CatalogueMgr.getTypeIdForName(val)
var typeId:int
var variantId:int = 0
var itemNumber:int 
var catalogueId:String: 
	get: 
		return CatalogueMgr.getCatalogueId(typeId, variantId, itemNumber)
var tier:int = 1

func _to_string():
	return "{%s}" % catalogueId

func _init(typeName:String="unknown"):
	self.typeId = CatalogueMgr.getTypeIdForName(typeName)

## override in subclasses
func applyGlobalVariantConfig(config:GlobalVariantConfig):
	pass

func resetNextRandomNumber(nextVal:int=0):
	_nextRandomNumber = nextVal

func getNextRandomNumber(useVariant=true) -> float:
	_nextRandomNumber += 1
	return getRandomNumber(_nextRandomNumber, useVariant)

func getNextRandomNumberFromType() -> float:
	return getNextRandomNumber(false)

## Returns a stable random number from 0 to 1, using the catalogue ID as a seed, with a salt to 
## allow multiple numbers to be created
func getRandomNumber(numberIdx:int, useVariant=true) -> float:
	var curSeed
	if useVariant:
		curSeed = (((typeId<<16) | variantId) + numberIdx)
	else:
		curSeed = (((typeId<<16)) + numberIdx)
	return Rand.stableFloat(curSeed)

func getRandomNumberFromType(numberIdx:int) -> float:
	return getRandomNumber(numberIdx, false)

func getDescription():
	return "A nondescript item"

func getPlayerActions(_player:Player) -> Array[PlayerAction]:
	return []

func setProp(k:String, val):
	props[k] = val

func getProp(k:String, default=null):
	return props.get(k, default)
