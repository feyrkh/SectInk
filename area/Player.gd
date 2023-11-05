extends CharacterBody2D
class_name Player

var speed = 220
var inputDisabledModal = false
var inventory = Inventory.new()

func _ready():
	AreaEvent.modalPanelOpened.connect(modalPanelOpened)
	AreaEvent.modalPanelClosed.connect(modalPanelClosed)
	# TODO: DELETE
	inventory.addItem(CatalogueMgr.generateRandomItem("powerGem", 22.7))
	inventory.addItem(CatalogueMgr.generateRandomItem("powerGem", 22.7))
	inventory.addItem(CatalogueMgr.generateRandomItem("powerGem", 22.7))
	inventory.addItem(CatalogueMgr.generateRandomItem("powerGem", 22.7))
	inventory.addItem(CatalogueMgr.generateRandomItem("powerGem", 22.7))

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	if !inputDisabledModal:
		get_input()
		move_and_slide()

func modalPanelOpened(_modal:Control):
	inputDisabledModal = true

func modalPanelClosed(_modal:Control):
	inputDisabledModal = false
