extends Control

static var TinkerPanelLabelScene:PackedScene = preload("res://area/machines/tinker/TinkerPanelLabel.tscn")
static var TinkerPanelControlScene:PackedScene = preload("res://area/machines/tinker/TinkerPanelControl.tscn")
static var TinkerPanelComponentScene:PackedScene = preload("res://area/machines/tinker/TinkerPanelComponent.tscn")
static var TinkerPanelDescriptionScene:PackedScene = preload("res://area/machines/tinker/TinkerPanelDescription.tscn")

@onready var TinkerOptions = find_child("TinkerOptions")
@onready var ComponentOptions = find_child("ComponentOptions")

var machine:BigMachine
var player:Player

func _ready():
	var controls:Array = machine.configSettingOptions.values()
	controls.sort_custom(func(a:MachineConfigOption, b:MachineConfigOption): return a.sortOrder < b.sortOrder)
	for control in controls:
		var label:Label = TinkerPanelLabelScene.instantiate()
		TinkerOptions.add_child(label)
		label.text = CatalogueMgr.getVocabulary(control.name)
		var slider = TinkerPanelControlScene.instantiate()
		slider.configure(control.valueSteps, machine.getMachineConfigStep(control.name), 
			func(value_changed): 
				if value_changed:
					machine.setMachineConfigStep(control.name, slider.value))
		TinkerOptions.add_child(slider)
	var components:Array[MachineComponentOption] = machine.componentOptions
	for component in components:
		var label:Label = TinkerPanelLabelScene.instantiate()
		ComponentOptions.add_child(label)
		label.text = CatalogueMgr.getVocabulary(component.name)
		var select:TinkerPanelComponent = TinkerPanelComponentScene.instantiate()
		ComponentOptions.add_child(select)
		var descriptionLabel:Label = TinkerPanelDescriptionScene.instantiate()
		ComponentOptions.add_child(descriptionLabel)
		if component.attachedComponent == null:
			descriptionLabel.text = ""
		else:
			descriptionLabel.text = component.attachedComponent.getDescription()
		select.configure(component, player.inventory, machine)
		select.item_selected.connect(func(idx):
			var item:InventoryItem = select.get_item_metadata(idx)
			if item == null:
				descriptionLabel.text = ""
			else:
				descriptionLabel.text = item.getDescription()
			component.swapComponents(item, player.inventory)
		)

func _process(_delta):
	if Input.is_action_just_pressed("action_menu_close"):
		queue_free()
		AreaEvent.modalPanelClosed.emit(self)
