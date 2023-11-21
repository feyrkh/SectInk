extends MachineOption
class_name MachineConfigOption

## The minimum value that this option can take
var minValue:float = 0
## The max value that this option can take
var maxValue:float = 1.0
## The number of steps between the min value and the max value which can be selected
var valueSteps:int = 5
var valueIncrement:float:
	get: return (maxValue - minValue)/valueSteps
## If true, the player is able to adjust this value. If false, it is stuck and invisible
var usable:bool = true

func getValueForStep(step:int) -> float:
	return minValue + (step * valueIncrement)

func _init(name:String, minValue:float, maxValue:float, valueSteps:int):
	self.name = name
	self.minValue = minValue
	self.maxValue = maxValue
	self.valueSteps = valueSteps

## given a random number generator and some values, generate a MachineConfigOption
## which can apply a correction value to compensate for some input which is not
## at the ideal value.
## For example, a specific machine has an ideal luminance level for its input
## gem of 0.5 for perfect operation, but the player has inserted a gem with a
## value of 0.3. A compensation slider would allow them to artificially dial
## the inserted gem's value up, getting it closer to ideal.
## For example:
##   steps = 3
##   stepIncrement = 0.07
##   offset = -0.03
## This means that if the slider is set to 0, the offset applied is -0.03, for a final gem value of 0.27
## If it's set to 1, we get -0.03 + (0.07 * 1) = 0.04, for a final gem value of 0.34
static func generateConfig(name:String, randGen:Callable, effectiveTier:int=1, minSteps=2, 
		maxBonusSteps=2, maxStepsPerTier=1, minTotalCorrection=0.05, maxBonusCorrection=0.05, 
		maxCorrectionPerTier=0.05) -> MachineConfigOption:
	var valueSteps = minSteps + randGen.call()*maxBonusSteps + randGen.call()*maxStepsPerTier*effectiveTier
	var maxValue = minTotalCorrection + randGen.call()*maxBonusCorrection + randGen.call()*maxCorrectionPerTier*effectiveTier
	var minValue = -randGen.call() * maxValue
	maxValue += minValue
	var result = MachineConfigOption.new(name, minValue, maxValue, valueSteps)
	return result
