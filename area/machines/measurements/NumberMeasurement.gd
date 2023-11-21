extends MachineMeasurement
class_name NumberMeasurement

var propName:String
var rangeEffectName:String
var precisionEffectName:String

func _init(name:String, propName:String, rangeEffectName:String, precisionEffectName:String):
	super(name)
	self.propName = propName
	self.rangeEffectName = rangeEffectName
	self.precisionEffectName = precisionEffectName

func getScenePath():
	return "res://area/machines/measurements/NumberMeasurementUI.tscn"

func measure(machine:BigMachine) -> float:
	if !checkInputs(machine):
		return 0
	var input = machine.inputOptions[0]
	var actualValue = input.getProp(name)
	var perceivedValue = actualValue
	var rangeEffect:RangeMachineEffect = machine.machineEffects.get(rangeEffectName)
	var precisionEffect:ResolutionMachineEffect = machine.machineEffects.get(precisionEffectName)
	var rangeCenter = machine.machineEffects.get(rangeEffectName)
	return perceivedValue

func checkInputs(machine:BigMachine) -> bool:
	if machine == null:
		return false
	if machine.inputOptions == null || machine.inputOption.size() < 1:
		push_error("Expected at least 1 inputOption for number measure %s in machine with type %s and catalogue %s" % [propName, machine.typeName, machine.catalogueId])
		return false
	if machine.inputOptions[0].attachedItem == null:
		return false # no item is in the input slot, always get a measurement of 0
	if machine.machineEffects.get(rangeEffectName) as RangeMachineEffect == null:
		push_error("Expected rangeEffectName=%s to exist in the machine effects with type %s and catalogue %s" % [rangeEffectName, machine.typeName, machine.catalogueId])
		return false
	if machine.machineEffects.get(precisionEffectName) as ResolutionMachineEffect == null:
		push_error("Expected precisionEffectName=%s to exist in the machine effects with type %s and catalogue %s" % [precisionEffectName, machine.typeName, machine.catalogueId])
		return false
	return true

func refresh():
	pass
