extends Control
class_name BaseMachinePanel

static var TinkerPanelLabelScene:PackedScene = load("res://area/machines/tinker/TinkerPanelLabel.tscn")
static var TinkerPanelControlScene:PackedScene = load("res://area/machines/tinker/TinkerPanelControl.tscn")
static var TinkerPanelComponentScene:PackedScene = load("res://area/machines/tinker/TinkerPanelComponent.tscn")
static var TinkerPanelDescriptionScene:PackedScene = load("res://area/machines/tinker/TinkerPanelDescription.tscn")

var machine:BigMachine
var player:Player

signal componentUpdated(oldComponent:InventoryItem, newComponent:InventoryItem)

func addComponentOption(optionContainer:Control, component:InventoryItemOption):
	addLabel(optionContainer, component.name)
	var select:TinkerPanelComponent = TinkerPanelComponentScene.instantiate()
	optionContainer.add_child(select)
	var descriptionLabel:Label = TinkerPanelDescriptionScene.instantiate()
	optionContainer.add_child(descriptionLabel)
	if component.attachedItem == null:
		descriptionLabel.text = ""
	else:
		descriptionLabel.text = component.attachedItem.getDescription()
	select.configure(component, player.inventory, machine)
	select.item_selected.connect(func(idx):
		var item:InventoryItem = select.get_item_metadata(idx)
		if item == null:
			descriptionLabel.text = ""
		else:
			descriptionLabel.text = item.getDescription()
		var componentUpdate:Array[InventoryItem] = component.swapComponents(item, player.inventory)
		componentUpdated.emit(componentUpdate[0], componentUpdate[1])
	)

func addLabel(optionContainer:Control, labelText:String):
	var label:Label = TinkerPanelLabelScene.instantiate()
	optionContainer.add_child(label)
	label.text = CatalogueMgr.getVocabulary(labelText)
