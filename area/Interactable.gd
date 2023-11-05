extends StaticBody2D
class_name Interactable

static var _nextRandomNumber:int = 0

@export var generateItemTypeOnSpawn:String = ""

const highlightColor:Color = Color(1.2, 1.2, 1.2)
var item:InventoryItem # the underlying item that this interactable UI element is representing

var typeId:int: 
	get: return item.typeId
var variantId:int:
	get: return item.variantId
var itemNumber:int:
	get: return item.itemNumber
var catalogueId:String:
	get: return item.catalogueId
var tier:int:
	get: return item.tier

func _ready():
	if generateItemTypeOnSpawn != null:
		item = CatalogueMgr.generateRandomItem(generateItemTypeOnSpawn)
		generateItemTypeOnSpawn = ""

func resetNextRandomNumber(nextVal:int=0):
	item.resetNextRandomNumber(nextVal)

func getNextRandomNumber(useVariant=true) -> float:
	return item.getNextRandomNumber(useVariant)

func getNextRandomNumberFromType() -> float:
	return item.getNextRandomNumberFromType()

## Returns a stable random number from 0 to 1, using the catalogue ID as a seed, with a salt to 
## allow multiple numbers to be created
func getRandomNumber(numberIdx:int, useVariant=true) -> float:
	return item.getRandomNumber(numberIdx, useVariant)

func getRandomNumberFromType(numberIdx:int) -> float:
	return item.getRandomNumberFromType(numberIdx)

func getPlayerActions(_player:Player) -> Array[PlayerAction]:
	return item.getPlayerActions(_player)

func _on_trigger_area_body_entered(body):
	if body is Player:
		print("Player entered the area of ", catalogueId)
		refreshPlayerActions(body)
		modulate = highlightColor

func refreshPlayerActions(player:Player):
	var actions = getPlayerActions(player)
	if actions != null && actions.size() > 0:
		AreaEvent.playerActionsAvailable.emit(player, self.item, actions)

func _on_trigger_area_body_exited(body):
	if body is Player:
		print("Player left the area of ", catalogueId)
		clearPlayerActions(body)
		modulate = Color.WHITE

func clearPlayerActions(player):
	AreaEvent.playerActionsRemoved.emit(player, self.item)
