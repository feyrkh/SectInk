extends GutTest

func test_constantValue():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("poise", 100)
	var below100 = {"poise": Stat.new("poise", 90)}
	var at100 = {"poise": Stat.new("poise", 100)}
	var above100 = {"poise": Stat.new("poise", 100.1)}
	var missing = {"strength": Stat.new("strength", 9001)}
	assert_eq(true, f.check(at100), "at100")
	assert_eq(false, f.check(below100), "below100")
	assert_eq(true, f.check(above100), "above100")
	assert_eq(false, f.check(missing), "missing")

func test_expressionOnCurStatReturningNumbers_belowHalf():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("poise", "maxValue/2")
	var poiseStatBelowHalf = BoundedStat.new("poise", 0, 100, 42)
	var inputBelowHalf = {"poise": poiseStatBelowHalf}
	assert_false(f.check(inputBelowHalf), "below half")

func test_expressionOnCurStatReturningNumbers_aboveHalf():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("poise", "maxValue/2")
	var poiseStatAboveHalf = BoundedStat.new("poise", 0, 100, 62)
	var inputAboveHalf = {"poise": poiseStatAboveHalf}
	assert_true(f.check(inputAboveHalf), "above half")

var boolStats = [
	[31, true, "above range"],
	[30, false, "on range"],
	[29, false, "below range"],
	[-10, false, "negative"],
]
func test_expressionOnCurStatReturningBools(p=use_parameters(boolStats)):
	var statValue = p[0]
	var expectedResult = p[1]
	var msg = p[2]
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "value > 30")
	var check = {"hp": BoundedStat.new("hp", 0, 100, statValue)}
	assert_eq(f.check(check), expectedResult, msg)

var multiStats = [
	[50, 50, true, "both above range"],
	[0, 0, false, "both below range"],
	[50, 10, false, "poise below range"],
	[10, 50, false, "hp below range"],
]
func test_expressionOnMultipleStats(p=use_parameters(multiStats)):
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "value > 30 && $poise.value > 30")
	var hp = p[0]
	var poise = p[1]
	var expected = p[2]
	var msg = p[3]
	var check = {"hp": Stat.new("hp", hp), "poise": Stat.new("poise", poise)}
	assert_eq(f.check(check), expected, msg)

func test_expressionUsingRandf():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "value + randf_range(1.1, 1.49) + 0.01")
	var check = {"hp": Stat.new("hp", 100)}
	var result = f.getValue(check)
	print("Result: ", result)
	assert_gt(result, 101.1, "greater than lower range")
	assert_lt(result, 101.5, "less than the upper range")

func test_expressionUsingMissingMainStat():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "value + $poise.value")
	var check = {"poise": Stat.new("poise", 50)}
	var result = f.getValue(check)
	assert_eq(result, 50.0)

func test_expressionUsingMissingSecondaryStat():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "value + $poise.value")
	var check = {"hp": Stat.new("hp", 100)}
	var result = f.getValue(check)
	assert_eq(result, 100.0)

func test_expressionUsingAllMissingStats():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "value + $poise.value")
	var check = {}
	var result = f.getValue(check)
	assert_eq(result, 0.0)

func test_expressionWithParseError():
	var f:ExpressionStatFunction = ExpressionStatFunction.new("hp", "valueee")
	var check = {"hp": Stat.new("hp", 100)}
	var result = f.getValue(check)
	assert_eq(result, 0.0)
