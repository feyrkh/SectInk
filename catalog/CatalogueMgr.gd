extends Node

var itemTypeToClass = {
	"powerGem": PowerGem,
	"crystalChecker": CrystalChecker,
}

var catalogueChars = "0123456789BCDFGHJKLMNPRSTVXYZ".split('')
var catalogueCharCount = catalogueChars.size()
var _nextTypeId = 0
## ex: crystalChecker -> 42
var typeNameToId:Dictionary = {}
var typeIdToUserDefinedName:Dictionary = {}
## ex: crystalChecker -> [{...}, {...}] where the array index is the variant ID and the values are GlobalVariantConfig instances   
var typeIdToVariantConfigArray:Dictionary = {}
var vocabulary:Dictionary = {}
var phonemes
var vowels = "aioy".split("")
var consonants = "bdfghjklmnpqrstvwxyz".split("")

## newVariantChance is a value added to the random variant roll, and it has less of an impact over time.
## For example, if the value is 0.1, then the first variant rolled will pick a random number from
## 0 to 0.1, then floor it, always giving a variant ID of 0. The next call will pick a random number from
## 0 to 1.1, then floor it. Most of the time it will choose variant 0 again, but about 91% of the time
## (0.1/1.1) it will create a new variant with the number 1. After two variant exist, it will roll from
## 0 to 2.1, creating variants 0 and 1 in equal proportion but dividing the chance of creating a variant
## 2 in half.
func generateRandomItem(itemType:String, newVariantChance:float = 0.1) -> InventoryItem:
	var itemClass = itemTypeToClass.get(itemType, InventoryItem)
	var item:InventoryItem = itemClass.new()
	item.typeId = getTypeIdForName(itemType)
	item.variantId = getRandomVariantId(item.typeId, newVariantChance)
	if !typeIdToVariantConfigArray.has(item.typeId):
		typeIdToVariantConfigArray[item.typeId] = []
	var variantConfigsArray = typeIdToVariantConfigArray.get(item.typeId)
	if item.variantId >= variantConfigsArray.size():
		var config:GlobalVariantConfig = GlobalVariantConfig.new()
		variantConfigsArray.append(config)
	var config = variantConfigsArray[item.variantId]
	var nextItemNumber:int = config.nextItemNumber
	config.nextItemNumber += 1
	item.itemNumber = nextItemNumber
	item.applyGlobalVariantConfig(config)
	if item.has_method("postConstruct"):
		item.postConstruct()
	return item

func getRandomVariantId(typeId:int, newVariantChance:float) -> int:
	var existingVariants:Array = typeIdToVariantConfigArray.get(typeId, [])
	if (existingVariants.size() == 0):
		return 0
	return min(existingVariants.size(), floor(randf_range(0, max(0, existingVariants.size()-0.0000001+newVariantChance))))

func getVocabulary(realName:String) -> String:
	if !vocabulary.has(realName):
		vocabulary[realName] = generateVocabulary(realName)
	return vocabulary[realName]

func getTypeIdForName(typeName:String) -> int:
	if typeNameToId.has(typeName):
		return typeNameToId[typeName]
	_nextTypeId += 1
	typeNameToId[typeName] = _nextTypeId
	return _nextTypeId

func getCatalogueId(typeId:int, variantId:int, itemNumber:int):
	return "%s [%s-%03d]" % [getTypeName(typeId), getVariantName(typeId, variantId), itemNumber]

func getTypeName(typeId:int) -> String:
	if typeIdToUserDefinedName.has(typeId):
		return typeIdToUserDefinedName[typeId]
	return buildId(typeId, 4)

func getVariantName(typeId:int, variantId:int) -> String:
	if typeIdToUserDefinedName.has(typeId):
		return typeIdToUserDefinedName[typeId]
	return buildVariantId(typeId, variantId, 3)

func buildId(id:int, idLength:int):
	var retval = ""
	for i in range(idLength):
		retval += catalogueChars[Rand.stableInt(id + i) % catalogueCharCount]
	return retval

func buildVariantId(typeId:int, variantId:int, idLength:int):
	return buildId(typeId << 32 | variantId, idLength)

func generateVocabulary(realName:String) -> String:
	if phonemes == null:
		phonemes = generatePhonemes()
	var words = realName.split(" ", false)
	if words.size() == 1:
		var result:Array[String] = []
		for i in range(randi_range(2, 5)):
			result.append(phonemes[randi_range(0, phonemes.size()-1)])
			if randf() < 0.05:
				result.append("'")
		return "".join(result)
	else:
		return " ".join(Array(words).map(func(word): return getVocabulary(word)))
	
func generatePhonemes():
	var result = []
	for i in range(50):
		result.append(vowels[randi_range(0, vowels.size()-1)] + consonants[randi_range(0, consonants.size()-1)])
	for i in range(50):
		result.append(consonants[randi_range(0, consonants.size()-1)] + vowels[randi_range(0, vowels.size()-1)])
	return result

func generateShuffledName(nestedArrays:Array) -> String:
	nestedArrays = nestedArrays.map(func (arr):
		if arr is Array:
			return generateShuffledName(arr)
		else:
			return arr)
	nestedArrays.shuffle()
	return " ".join(nestedArrays)
