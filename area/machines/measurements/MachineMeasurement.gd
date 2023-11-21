extends Resource
class_name MachineMeasurement

var name:String

func _init(name:String):
	self.name = name

func buildUI(machine:BigMachine):
	var result = load(getScenePath()).instantiate()
	machine.measurementRefreshNeeded.connect(result.refresh)
	return result

func getScenePath():
	return "res://area/machines/measurements/BAD_MEASUREMENT.tscn"
