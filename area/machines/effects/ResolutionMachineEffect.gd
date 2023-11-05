extends MachineEffect
class_name ResolutionMachineEffect

var _resolution:float
var _resolutionReductionPerUnit:float
var _maxResolution:float
var _minResolution:float

# Resolution of 0.001 means that a value of 0.0015 through 0.0019 is reported as 0.002, while 0.0014
# is reported as 0.001. A reduction per unit of 5 means that for ever 1.0 discrepancy, we multiply
# the effective resolution by 5, so a resolution of 0.001 becomes 0.005, and a value of 0.0019 would
# then be rounded to 0.0
func _init(name:String, resolution:float, resolutionReductionPerUnit:float, maxResolution:float=1.0, minResolution=0.000001, requirementType:MachineEffect.RequirementType=MachineEffect.RequirementType.EXACT_VALUE):
	super(name, requirementType)
	self._resolution = resolution
	self._resolutionReductionPerUnit = resolutionReductionPerUnit
	self._maxResolution = maxResolution
	self._minResolution = minResolution

func getResolution(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	var deviation = abs(getDeviationFromIdeal(machineOption, actualComponent))
	var effectiveResolution = _resolution * (_resolutionReductionPerUnit * deviation)
	return clampf(effectiveResolution, _minResolution, _maxResolution)

func measure(machineOption:MachineComponentOption, actualComponent:MachineComponent, value:float) -> float:
	return snappedf(value, getResolution(machineOption, actualComponent))
