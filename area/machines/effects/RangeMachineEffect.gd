extends MachineEffect
class_name RangeMachineEffect

var _centerpoint:float
var _radius:float
var _radiusShrinkPerUnit:float
var _radiusMin:float

# Creates a range centered at a specific spot, with a radius of a specific value.
# If the ideal value of the component that affects this doesn't match, then multiply the radius
# by 1-abs(differenceFromIdeal * radiusShrinkPerUnit) to a minimum of radiusMin
func _init(name:String, rangeCenterpoint:float, rangeRadius:float, radiusShrinkPerUnit:float, radiusMin:float = 0.005, requirementType:MachineEffect.RequirementType=MachineEffect.RequirementType.EXACT_VALUE):
	super(name, requirementType)
	self._centerpoint = rangeCenterpoint
	self._radius = rangeRadius
	self._radiusShrinkPerUnit = radiusShrinkPerUnit
	self._radiusMin = radiusMin

func getCenterpoint(_machineOption:MachineComponentOption, _actualComponent:MachineComponent) -> float:
	return _centerpoint

func getRadius(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	var deviation = getDeviationFromIdeal(machineOption, actualComponent)
	return max(_radiusMin, _radius * (1 - abs(_radiusShrinkPerUnit * deviation)))
