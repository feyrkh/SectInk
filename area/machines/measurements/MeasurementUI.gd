extends Label
class_name MeasurementUI

var machine:BigMachine

func configure(machine:BigMachine):
	self.machine = machine
	machine.parametersChanged.connect(refresh)

func refresh():
	pass
