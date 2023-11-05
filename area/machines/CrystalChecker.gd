extends BigMachine
class_name CrystalChecker

func generateMachineEffects() -> Array[MachineEffect]:
	var result = super.generateMachineEffects()
	result.append_array([
		# range starts at some random number from 0-1, and width is 0.1 + rand(0, (tier+1)*0.05)
		# A tier 0 machine  has a range from 0.1 to 0.15, covering 20 to 30% of the range if perfectly
		# component slotted. A difference of 50% from the ideal would give a reduction of 15%, for a range of
		# 5 - 15%
		RangeMachineEffect.new("hue zoom", getNextRandomNumber(), 0.1 + getNextRandomNumber() * tier * 0.05, 0.3),
		RangeMachineEffect.new("luminance zoom", getNextRandomNumber(), 0.1 + getNextRandomNumber() * tier * 0.05, 0.3),
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

	var results = {}

	if !missingLuminanceRange:
		results["luminance range"] = luminanceRangeOption
	if !missingHueRange:
		results["hue range"] = hueRangeOption
	if !missingLuminancePrecision:
		results["luminance precision"] = luminancePrecisionOption
	if !missingHuePrecision:
		results["hue precision"] = huePrecisionOption
	return results
