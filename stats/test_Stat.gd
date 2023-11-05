extends GutTest


func test_setAndGet():
	var stat:Stat = Stat.new("stat", 100)
	assert_eq(stat.value, 100.0, "constructed")
	stat.value = 42
	assert_eq(stat.value, 42.0, "after set")
