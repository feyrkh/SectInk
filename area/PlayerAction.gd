extends RefCounted
class_name PlayerAction

var actor:Player
var source:InventoryItem
var name:String = "(unknown)"
var desc:String = "(unknown)"
var function:Callable


func _init(source:InventoryItem, name:String, desc:String, function:Callable):
	self.source = source
	self.name = name
	self.desc = desc
	self.function = function

func act():
	function.call(self)
