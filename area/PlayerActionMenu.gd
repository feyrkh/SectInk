extends PanelContainer

const UP_ARROW_TEXT = "^"
const MID_ARROW_TEXT = ">"
const DOWN_ARROW_TEXT = "v"

var selectedIdx:int = 0
var selectedAction:PlayerAction
var availableActions:Array[PlayerAction] = []
var inputDisabledModal = false

@onready var UpArrow:Node = find_child("UpArrow")
@onready var DownArrow:Node = find_child("DownArrow")
@onready var UpArrow2:Node = find_child("UpArrow2")
@onready var DownArrow2:Node = find_child("DownArrow2")
@onready var SelectedAction:Label = find_child("SelectedAction")
@onready var PrevAction:Label = find_child("PrevAction")
@onready var NextAction:Label = find_child("NextAction")

# Called when the node enters the scene tree for the first time.
func _ready():
	AreaEvent.playerActionsAvailable.connect(onPlayerActionsAvailable)
	AreaEvent.playerActionsRemoved.connect(onPlayerActionsRemoved)
	AreaEvent.playerActionsAllRemoved.connect(onPlayerActionsAllRemoved)
	AreaEvent.modalPanelOpened.connect(modalPanelOpened)
	AreaEvent.modalPanelClosed.connect(modalPanelClosed)
	refresh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !inputDisabledModal:
		if Input.is_action_just_pressed("action_menu_select"):
			if selectedAction != null:
				selectedAction.act()
		elif Input.is_action_just_pressed("action_menu_up"):
			selectedIdx -= 1
			refresh()
		elif Input.is_action_just_pressed("action_menu_down"):
			selectedIdx += 1
			refresh()

func refresh():
	if !is_instance_valid(selectedAction):
		selectedIdx = 0
	selectedIdx = clampi(selectedIdx, 0, max(0, availableActions.size()-1))
	if availableActions.size() == 0:
		visible = false
		return
	visible = true
	selectedAction = availableActions[selectedIdx]
	SelectedAction.text = selectedAction.name
	if selectedIdx > 0:
		PrevAction.text = availableActions[selectedIdx - 1].name
	else:
		PrevAction.text = " "
	if selectedIdx > 1:
		UpArrow.text = UP_ARROW_TEXT
		UpArrow2.text = UP_ARROW_TEXT
	else:
		UpArrow.text = " "
		UpArrow2.text = " "
	if selectedIdx < availableActions.size() - 1:
		NextAction.text = availableActions[selectedIdx + 1].name
	else:
		NextAction.text = " "
	if selectedIdx < availableActions.size() - 2:
		DownArrow.text = DOWN_ARROW_TEXT
		DownArrow2.text = DOWN_ARROW_TEXT
	else:
		DownArrow.text = " "
		DownArrow2.text = " "

func onPlayerActionsAvailable(player:Player, source:InventoryItem, actions:Array[PlayerAction]):
	for action in actions:
		action.source = source
		action.actor = player
	availableActions.append_array(actions)
	refresh()

func onPlayerActionsRemoved(_player:Player, source:InventoryItem):
	availableActions = availableActions.filter(func(action): return action.source != source)
	selectedIdx = availableActions.find(selectedAction)
	refresh()

func onPlayerActionsAllRemoved(_player:Player):
	selectedIdx = 0
	availableActions = []
	refresh()

func modalPanelOpened(_modal:Control):
	inputDisabledModal = true

func modalPanelClosed(_modal:Control):
	inputDisabledModal = false
