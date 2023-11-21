extends BigMachine
class_name CrystalChecker

func generateInputItemOptions() -> Array[InventoryItemOption]:
	var result = super.generateInputItemOptions()
	var tmpProps = []
	if configSettingOptions.has("luminance range") || configSettingOptions.has("luminance precision"):
		tmpProps.append("luminance")
	if configSettingOptions.has("hue range") || configSettingOptions.has("hue precision"):
		tmpProps.append("hue")
	result.append_array([
		InventoryItemOption.new("input", tmpProps)
	])
	return result

func generateMachineEffects() -> Array[MachineEffect]:
	var result = super.generateMachineEffects()
	result.append_array([
		# range starts at some random number from 0-1, and width is 0.1 + rand(0, (tier+1)*0.05)
		# A tier 0 machine  has a range from 0.1 to 0.15, covering 20 to 30% of the range if perfectly
		# component slotted. A difference of 50% from the ideal would give a reduction of 15%, for a range of
		# 5 - 15%
		RangeMachineEffect.new("hue range", getNextRandomNumber(), 0.1 + getNextRandomNumber() * tier * 0.05, 0.3),
		RangeMachineEffect.new("luminance range", getNextRandomNumber(), 0.1 + getNextRandomNumber() * tier * 0.05, 0.3),
		ResolutionMachineEffect.new("hue precision", 0.001 + getNextRandomNumber() * 0.01, getNextRandomNumber()*30),
		ResolutionMachineEffect.new("luminance precision", 0.001 + getNextRandomNumber() * 0.01, getNextRandomNumber()*30),
	])
	return result

func generateComponentOptions() -> Array[MachineComponentOption]:
	var result = super.generateComponentOptions()
	var requiredFields = ["luminance", "hue"]
	requiredFields.shuffle()
	var inputConfig = getNextRandomNumber() / max(1, tier)

	# 1 power source
	var zoomFocusOrder = ["zoom", "focus"]
	zoomFocusOrder.shuffle()
	zoomFocusOrder = " ".join(zoomFocusOrder)
	var hueLumOrder = ["hue", "luminance"]
	hueLumOrder.shuffle()
	hueLumOrder = " ".join(hueLumOrder)
	var fullName = CatalogueMgr.generateShuffledName([["zoom", "focus"], ["hue", "luminance"]])
	result.append(MachineComponentOption.new(fullName, # name of the option in the UI
		["hue zoom", "hue focus", "luminance zoom", "luminance focus"], # which effects of the machine are affected
		{"hue":getNextRandomNumber(), "luminance":getNextRandomNumber()} # which properties of the component affect these effects
	))
	return result

func generateConfigOptions() -> Dictionary:
	var result = super.generateConfigOptions()
	var missingLuminanceRange = getNextRandomNumber() < 0.15
	var missingHueRange = getNextRandomNumber() < 0.15
	var missingLuminancePrecision = getNextRandomNumber() < 0.15
	var missingHuePrecision = getNextRandomNumber() < 0.15
	var missingTierBonus = 3 if missingLuminanceRange else 0 + 3 if missingHueRange else 0 + 3 if missingLuminancePrecision else 0 + 3 if missingHuePrecision else 0 
	var effectiveTier = tier + missingTierBonus
	
	var luminanceRangeOption = MachineConfigOption.generateConfig("luminance range", self.getNextRandomNumber, effectiveTier, 2, 2, 1, 0.05, 0.05, 0.05)
	var luminancePrecisionOption = MachineConfigOption.generateConfig("luminance precision", self.getNextRandomNumber, effectiveTier, 2, 2, 1, 0.05, 0.05, 0.05)
	var hueRangeOption = MachineConfigOption.generateConfig("hue range", self.getNextRandomNumber, effectiveTier, 2, 2, 1, 0.05, 0.05, 0.05)
	var huePrecisionOption = MachineConfigOption.generateConfig("hue precision", self.getNextRandomNumber, effectiveTier, 2, 2, 1, 0.05, 0.05, 0.05)
	
	if missingLuminanceRange:
		luminanceRangeOption.usable = false
	if missingHueRange:
		hueRangeOption.usable = false
	if missingLuminancePrecision:
		luminancePrecisionOption.usable = false
	if missingHuePrecision:
		huePrecisionOption.usable = false

	var results = {}

	results["luminance range"] = luminanceRangeOption
	results["hue range"] = hueRangeOption
	results["luminance precision"] = luminancePrecisionOption
	results["hue precision"] = huePrecisionOption
	return results

func generateMeasurementOptions() -> Array[MachineMeasurement]:
	return [
		NumberMeasurement.new("luminance", "luminance", "luminance range", "luminance precision"),
		NumberMeasurement.new("hue", "hue", "hue range", "hue precision"),
	]
