extends Stat
class_name BoundedStat

signal changedToMin(stat:BoundedStat)
signal changedToMax(stat:BoundedStat)

var minValue:float
var maxValue:float
var percent:float:
	get:
		if maxValue == 0: 
			return 0
		return (value-minValue)/(maxValue-minValue)

func _init(name:String, minValue:float, maxValue:float, value:float=maxValue):
	self.minValue = minValue
	self.maxValue = maxValue
	super(name, value)

func _to_string():
	return "%s: %d/%d" % [name, value, maxValue]

func getValue():
	return value

func set_value(val):
	if val == value: return
	var prev:float = val
	value = clampf(val, minValue, maxValue)
	valueChanged.emit(self, prev, value)
	if value == minValue:
		changedToMin.emit(self)
	elif value == maxValue:
		changedToMax.emit(self)

## Returns a value that represents a specific percentage of the total range of the stat bounds
## ex: if min=0, max=100, then get_percent(0.3) returns 30
## ex: if min=50, max=150, then get_percent(0.3) still returns 30
func get_percent(fraction:float) -> float:
	var rangeWidth = maxValue-minValue
	return rangeWidth * fraction
