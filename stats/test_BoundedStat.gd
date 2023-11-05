extends GutTest

func test_percentage():
	var stat = BoundedStat.new("stat", 0, 100, 50)
	assert_eq(stat.percent, 0.5)
	stat.maxValue = 200
	assert_eq(stat.percent, 0.25)
	stat.minValue = 50.0
	assert_eq(stat.percent, 0.0)
	stat.minValue = 0.0
	stat.value = 23.1
	assert_eq(stat.percent, 0.1155)
