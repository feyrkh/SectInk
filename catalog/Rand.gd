extends Node

var hashSalt = randi()

func stableInt(intId:int) -> int:
	return rand_from_seed(intId ^ hashSalt)[0]

func stableFloat(curSeed:int) -> float:
	var baseNum = abs(rand_from_seed(curSeed ^ hashSalt)[0])
	var maxFloat = float(4294967296)
	var result = baseNum / maxFloat
	return result
