extends BaseMachinePanel

@onready var TinkerOptions = find_child("TinkerOptions")
@onready var ComponentOptions = find_child("ComponentOptions")

func _ready():
	var controls:Array = machine.configSettingOptions.values()
	controls.sort_custom(func(a:MachineConfigOption, b:MachineConfigOption): return a.sortOrder < b.sortOrder)
	for control in controls:
		if control.usable:
			addSliderControl(TinkerOptions, control)
	var components:Array[MachineComponentOption] = machine.componentOptions
	for component in components:
		addComponentOption(ComponentOptions, component)

func addSliderControl(container:Control, control:MachineConfigOption):
	var label:Label = TinkerPanelLabelScene.instantiate()
	TinkerOptions.add_child(label)
	label.text = CatalogueMgr.getVocabulary(control.name)
	var slider = TinkerPanelControlScene.instantiate()
	slider.configure(control.valueSteps, machine.getMachineConfigStep(control.name), 
		func(value_changed): 
			if value_changed:
				machine.setMachineConfigStep(control.name, slider.value))
	TinkerOptions.add_child(slider)

func _process(_delta):
	if Input.is_action_just_pressed("action_menu_close"):
		closePanel()

func closePanel():
	queue_free()
	AreaEvent.modalPanelClosed.emit(self)

func _on_close_button_pressed():
	closePanel()

func _on_use_button_pressed():
	closePanel()
	var action:PlayerAction = PlayerAction.new(machine, "Use", "Use equipment", machine.startUsing)
	action.actor = player
	machine.startUsing(action)
