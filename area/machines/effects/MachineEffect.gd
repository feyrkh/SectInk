extends RefCounted
class_name MachineEffect

enum RequirementType {EXACT_VALUE, GREATER_THAN, LESS_THAN, INVERSE_VALUE}

var name:String
var requirementType:RequirementType

func _init(name:String, requirementType:RequirementType = RequirementType.EXACT_VALUE):
	self.name = name
	self.requirementType = requirementType

func buildEffectUI(machine:BigMachine) -> Control:
	var result:Control = load("res://area/machines/effects/NumberMachineEffectUI.tscn").instantiate()
	result.configure(self, machine)
	return result

func getDeviationFromIdeal(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	match requirementType:
		RequirementType.EXACT_VALUE: return _getDeviationFromIdealExact(machineOption, actualComponent)
		RequirementType.GREATER_THAN: return _getDeviationFromIdealGreaterThan(machineOption, actualComponent)
		RequirementType.LESS_THAN: return _getDeviationFromIdealLessThan(machineOption, actualComponent)
		RequirementType.INVERSE_VALUE: return _getDeviationFromIdealInverseExact(machineOption, actualComponent)
		_: return _getDeviationFromIdealExact(machineOption, actualComponent)

func _getDeviationFromIdealExact(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	var diffSum = 0
	for prop in machineOption.propIdealValues:
		var idealVal = machineOption.propIdealValues[prop]
		var actualVal = actualComponent.getProp(prop, -1)
		diffSum += idealVal - actualVal
	return diffSum

func _getDeviationFromIdealInverseExact(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	var normalDev = _getDeviationFromIdealExact(machineOption, actualComponent)
	if normalDev == 0:
		return 1.0
	else:
		return sign(normalDev) * 1.0 - normalDev

func _getDeviationFromIdealGreaterThan(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	var diffSum = 0
	for prop in machineOption.propIdealValues:
		var idealVal = machineOption.propIdealValues[prop]
		var actualVal = actualComponent.getProp(prop, -1)
		if actualVal >= idealVal:
			continue
		diffSum += idealVal - actualVal
	return diffSum
	
func _getDeviationFromIdealLessThan(machineOption:MachineComponentOption, actualComponent:MachineComponent) -> float:
	var diffSum = 0
	for prop in machineOption.propIdealValues:
		var idealVal = machineOption.propIdealValues[prop]
		var actualVal = actualComponent.getProp(prop, -1)
		if actualVal <= idealVal:
			continue
		diffSum += idealVal - actualVal
	return diffSum
	
