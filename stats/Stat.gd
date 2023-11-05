extends RefCounted
class_name Stat

signal valueChanged(stat:Stat, prev:float, next:float)

var name
var value:float: get=getValue, set=setValue

func _init(name:String, value:float=0):
	self.value = value
	self.name = name

func _to_string():
	return "%s: %d" % [name, value]
	
func getValue():
	return value

func setValue(val):
	if val == value: 
		return
	var prev:float = val
	value = val
	valueChanged.emit(self, prev, val)
