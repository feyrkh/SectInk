extends InventoryItem
class_name BigMachine

signal measurementRefreshNeeded

var configSettings:Dictionary = {}
var configSettingOptions:Dictionary:
	get:
		if configSettingOptions.size() == 0:
			configSettingOptions = generateConfigOptions()
			var sortIdx = 0
			for configSetting in configSettingOptions.values():
				if configSetting.sortOrder == null:
					configSetting.sortOrder = getRandomNumber(sortIdx)
					sortIdx += 1
		return configSettingOptions
var componentOptions:Array[MachineComponentOption]:
	get:
		if componentOptions.size() == 0:
			componentOptions = generateComponentOptions()
			var sortIdx = 0
			for componentOption in componentOptions:
				if componentOption.sortOrder == null:
					componentOption.sortOrder = getRandomNumber(sortIdx)
					sortIdx += 1
		return componentOptions

var inputOptions:Array[InventoryItemOption]:
	get:
		if inputOptions.size() == 0:
			inputOptions = generateInputItemOptions()
		return inputOptions

var measurements:Array[MachineMeasurement]:
	get:
		if measurements.size() == 0:
			measurements = generateMeasurementOptions()
			var sortIdx = 0
			for opt in measurements:
				if opt.sortOrder == null:
					opt.sortOrder = getRandomNumber(sortIdx)
					sortIdx += 1
		return measurements
	

## machineEffects: effectName -> MachineEffect
var machineEffects:Dictionary:
	get:
		if machineEffects.size() == 0:
			var effects:Array[MachineEffect]
			for effect in generateMachineEffects():
				machineEffects[effect.name] = effect
		return machineEffects

func _init(typeName:String="unknownMachine"):
	super(typeName)

## Subclasses should override this, and may want to use the `tier` property to decide how powerful
## the available options are, or maybe use sub-components.
func generateConfigOptions() -> Dictionary:
	resetNextRandomNumber(100)
	return {}

func generateComponentOptions() -> Array[MachineComponentOption]:
	resetNextRandomNumber(200)
	return []

func generateMachineEffects() -> Array[MachineEffect]:
	resetNextRandomNumber(300)
	return []

func generateInputItemOptions() -> Array[InventoryItemOption]:
	resetNextRandomNumber(400)
	return []

func generateMeasurementOptions() -> Array[MachineMeasurement]:
	resetNextRandomNumber(500)
	return []

func getMachineConfigStep(configName:String) -> int:
	if !configSettings.has(configName):
		var setting = generateConfigSetting(configName)
		if setting:
			configSettings[configName] = setting
		else:
			return 0
	return configSettings[configName]

func setMachineConfigStep(configName:String, newValue:int):
	configSettings[configName] = newValue

func getMachineConfigValue(configName:String) -> float:
	if !configSettingOptions.has(configName):
		return 0
	var option:MachineConfigOption = configSettingOptions[configName]
	var step:int = getMachineConfigStep(configName)
	return option.getValueForStep(step)

## Pick a random value within the range of the named MachineConfigOption
func generateConfigSetting(configName:String):
	if !configSettingOptions.has(configName):
		return null
	var configOption:MachineConfigOption = configSettingOptions[configName]
	return randi_range(0, configOption.valueSteps)

func getPlayerActions(_player:Player) -> Array[PlayerAction]:
	return [
		PlayerAction.new(self, "Use", "Use This Thing", self.startUsing),
		PlayerAction.new(self, "Tinker", "Tinker", self.startTinkering),
	]

func startTinkering(action:PlayerAction):
	print("Tinkering started: ", self)
	var TinkerPanelScene:PackedScene = preload("res://area/machines/tinker/TinkerPanel.tscn")
	var modal = TinkerPanelScene.instantiate()
	modal.machine = self
	modal.player = action.actor
	AreaEvent.modalPanelOpened.emit(modal)

func startUsing(action:PlayerAction):
	print("Use started: ", self)
	var UsePanelScene:PackedScene = preload("res://area/machines/use/UsePanel.tscn")
	var modal = UsePanelScene.instantiate()
	modal.machine = self
	modal.player = action.actor
	AreaEvent.modalPanelOpened.emit(modal)
