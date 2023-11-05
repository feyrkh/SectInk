extends RefCounted
class_name StatFunction

var statName:String

func _init(statName:String):
	self.statName = statName

func getValue(statHolder):
	if !statHolder: return 0
	var statObj:Stat = statHolder.get(statName)
	if !statObj: return 0
	return statObj.value

## Returns 'true' if the statHolder has a stat of the correct name with a value > 0
func check(statHolder):
	return getValue(statHolder) > 0
