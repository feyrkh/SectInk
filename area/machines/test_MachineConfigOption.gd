extends GutTest

func test_simpleCreate():
	var result = MachineConfigOption.new("name", 0, 100, 10)
	assert_eq(result.minValue, 0.0)
	assert_eq(result.maxValue, 100.0)
	assert_eq(result.valueSteps, 10)
	assert_eq(result.getValueForStep(0), 0.0)
	assert_eq(result.getValueForStep(10), 100.0)
	assert_eq(result.getValueForStep(5), 50.0)
