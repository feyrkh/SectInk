extends GutTest

var origSalt

func before_each():
	origSalt = Rand.hashSalt

func after_each():
	Rand.hashSalt = origSalt

func test_stableFloat():
	Rand.hashSalt = 54
	var i = 0
	var minNum = 10000
	var maxNum = -10000
	var sum = 0
	var count = 150000
	while i < count:
		var cur = Rand.stableFloat(i)
		minNum = min(minNum, cur)
		maxNum = max(maxNum, cur)
		sum += cur
		i += 1
	print("Range: ", minNum, " to ", maxNum)
	print("Average: ", sum/count)
	assert_almost_eq(minNum, 0.0, 0.00001, "minimum value received")
	assert_almost_eq(maxNum, 1.0, 0.00001, "maximum value received")
	assert_almost_eq(sum/count, 0.5, 0.0001, "average value")

func test_floatsRepeatableWithSalt():
	Rand.hashSalt = 1042
	var expectedVals = [0.12297326279804, 0.60309716872871, 0.05476853065193, 0.7830632221885]
	for i in range(expectedVals.size()):
		var cur = Rand.stableFloat(i)
		print("Random val ", i, ": ", cur)
		assert_almost_eq(cur, expectedVals[i], 0.0000000000001, str(i))

func test_intsRepeatableWithSalt():
	Rand.hashSalt = 555
	var expectedVals = [3255164970, 288857534, 2393596571, 1184607995]
	for i in range(expectedVals.size()):
		var cur = Rand.stableInt(i)
		print("Random val ", i, ": ", cur)
		assert_eq(cur, expectedVals[i], str(i))
