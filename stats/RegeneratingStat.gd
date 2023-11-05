extends BoundedStat
class_name RegeneratingStat

var regen:float:
	get:
		return regen
	set(val):
		regen = val

func _init(statName:String, minValue:float, maxValue:float, regen:float, value:float=maxValue):
	super(statName, minValue, maxValue, value)
	self.regen = regen

func _to_string():
	return "%s: %d/%d (+%.1f/s)" % [name, value, maxValue, regen]

func tick(t:float):
	value += regen * t
