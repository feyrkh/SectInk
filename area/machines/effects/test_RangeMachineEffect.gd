extends GutTest

const DELTA:float = 0.00000001

func test_rangeReductionWorks():
	# Range with centerpoint of 0.5, range of 0.1, which shrinks by 1.0 with at 100% discrepancy and a min of 0
	var effect = RangeMachineEffect.new("effect", 0.5, 0.1, 1.0, 0)
	var opt = MachineComponentOption.new("option", ["effect"], {"prop": 0.5})
	var cmp = MachineComponent.new()
	# Exact match
	cmp.configure("type", 0, 0, 0, {"prop": 0.5})
	assert_eq(effect.getCenterpoint(opt, cmp), 0.5)
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "exact match with required props")
	
	cmp.configure("type", 0, 0, 0, {"prop": 0.25})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.075, DELTA, "-0.25 deviation, shrink by 25%")
	cmp.configure("type", 0, 0, 0, {"prop": 0.75})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.075, DELTA, "+0.25 deviation, shrink by 25%")
	cmp.configure("type", 0, 0, 0, {"prop": 0.0})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.05, DELTA, "0.5 deviation, shrink by 50%")
	
	# Range with centerpoint of 0.5, range of 0.1, which shrinks by 2.0 with at 100% discrepancy and a min of 0
	cmp.configure("type", 0, 0, 0, {"prop": 0.0})
	effect = RangeMachineEffect.new("effect", 0.5, 0.1, 2.0, 0)
	assert_almost_eq(effect.getRadius(opt, cmp), 0.0, DELTA, "0.5 deviation, shrink by 100%")

func test_minRangeWorks():
	# Discrepancy of 1.0, 500% drop per discrepancy of 100
	var effect = RangeMachineEffect.new("effect", 0.5, 0.1, 1.0, 0.00002345)
	var opt = MachineComponentOption.new("option", ["effect"], {"prop": 1.0})
	var cmp = MachineComponent.new()
	cmp.configure("type", 0, 0, 0, {"prop": 0.0})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.00002345, DELTA)
	
	
func test_inverseEffectType():
	var effect = RangeMachineEffect.new("effect", 0.5, 0.1, 1.0, 0, MachineEffect.RequirementType.INVERSE_VALUE)
	var opt = MachineComponentOption.new("option", ["effect"], {"prop": 0.5})
	var cmp = MachineComponent.new()
	# Exact match, gives minimum result
	cmp.configure("type", 0, 0, 0, {"prop": 0.5})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.0, DELTA, "exact match with required props")
	# 0.5 below the inverse-ideal
	cmp.configure("type", 0, 0, 0, {"prop": 0.0})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.05, DELTA, "0.5 below required props")
	# 0.5 above the inverse-ideal
	cmp.configure("type", 0, 0, 0, {"prop": 1.0})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.05, DELTA, "0.5 above required props")
	
func test_lessThanEffectType():
	var effect = RangeMachineEffect.new("effect", 0.5, 0.1, 1.0, 0, MachineEffect.RequirementType.LESS_THAN)
	var opt = MachineComponentOption.new("option", ["effect"], {"prop": 0.5})
	var cmp = MachineComponent.new()
	# Exact match, gives maximum result
	cmp.configure("type", 0, 0, 0, {"prop": 0.5})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "exact match with required props")
	# Much less, still gives maximum result
	cmp.configure("type", 0, 0, 0, {"prop": 0.1})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "exact match with required props")
	# Slightly more, still gives lower result (0.1 discrepancy, 1.0 per unit drop, so 10% lower value expected
	cmp.configure("type", 0, 0, 0, {"prop": 0.6})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.09, DELTA, "exact match with required props")
	
	
	
func test_greaterThanEffectType():
	var effect = RangeMachineEffect.new("effect", 0.5, 0.1, 1.0, 0, MachineEffect.RequirementType.GREATER_THAN)
	var opt = MachineComponentOption.new("option", ["effect"], {"prop": 0.5})
	var cmp = MachineComponent.new()
	# Exact match, gives maximum result
	cmp.configure("type", 0, 0, 0, {"prop": 0.5})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "exact match with required props")
	# Much higher, still gives maximum result
	cmp.configure("type", 0, 0, 0, {"prop": 1.0})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "exact match with required props")
	# Slightly lower, still gives lower result (0.2 discrepancy, 1.0 per unit drop, so 20% lower value expected
	cmp.configure("type", 0, 0, 0, {"prop": 0.3})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.08, DELTA, "exact match with required props")
	
func test_multipleProps():
	var effect = RangeMachineEffect.new("effect", 0.5, 0.1, 1.0, 0, MachineEffect.RequirementType.EXACT_VALUE)
	var opt = MachineComponentOption.new("option", ["effect"], {"prop": 0.5, "prop2": 0.7})
	var cmp = MachineComponent.new()
	# Exact match, gives maximum result
	cmp.configure("type", 0, 0, 0, {"prop": 0.5, "prop2": 0.7})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "exact match with required props")
	# Opposite balanced discrepancies, gives maximum result
	cmp.configure("type", 0, 0, 0, {"prop": 0.4, "prop2": 0.8})
	assert_almost_eq(effect.getRadius(opt, cmp), 0.1, DELTA, "opposite balanced discrepancies")
	# Opposite unbalanced discrepancies, gives lower result
	cmp.configure("type", 0, 0, 0, {"prop": 0.3, "prop2": 0.8}) # overall -0.1 discrepancy
	assert_almost_eq(effect.getRadius(opt, cmp), 0.09, DELTA, "opposite unbalanced discrepancies")
	# Same direction discrepancies, gives larger result
	cmp.configure("type", 0, 0, 0, {"prop": 0.4, "prop2": 0.6}) # overall -0.2 discrepancy
	assert_almost_eq(effect.getRadius(opt, cmp), 0.08, DELTA, "opposite unbalanced discrepancies")
	
