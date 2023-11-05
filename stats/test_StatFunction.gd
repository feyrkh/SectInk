extends GutTest

func test_basic():
	var f:StatFunction = StatFunction.new("poise")
	var below100 = {"poise": Stat.new("poise", 90)}
	var at100 = {"poise": Stat.new("poise", 100)}
	var above100 = {"poise": Stat.new("poise", 100.1)}
	var missing = {"strength": Stat.new("strength", 9001)}
	assert_eq(true, f.check(below100), "below100")
	assert_eq(true, f.check(at100), "at100")
	assert_eq(true, f.check(above100), "above100")
	assert_eq(false, f.check(missing), "missing")
