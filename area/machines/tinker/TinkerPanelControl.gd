extends HSlider

func configure(valueSteps:int, curValueStepValue:int, onDragEnded:Callable):
	tick_count = valueSteps + 1
	min_value = 0
	max_value = valueSteps
	value = curValueStepValue
	drag_ended.connect(onDragEnded)
