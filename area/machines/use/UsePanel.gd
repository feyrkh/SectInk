extends BaseMachinePanel

@onready var ComponentOptions = find_child("ComponentOptions")
@onready var Measurements = find_child("Measurements")

# Called when the node enters the scene tree for the first time.
func _ready():
	var components:Array[InventoryItemOption] = machine.inputOptions
	for component in components:
		addComponentOption(ComponentOptions, component)
	for measure in machine.measurements:
		addLabel(Measurements, CatalogueMgr.getVocabulary(measure.name))
		addMeasurement(measure)

func _process(_delta):
	if Input.is_action_just_pressed("action_menu_close"):
		closePanel()

func closePanel():
	queue_free()
	AreaEvent.modalPanelClosed.emit(self)

func addMeasurement(measure:MachineMeasurement):
	var ui = measure.buildUI(machine)
	Measurements.add_child(ui)

func _on_close_button_pressed():
	closePanel()

func _on_tinker_button_pressed():
	closePanel()
	var action:PlayerAction = PlayerAction.new(machine, "Tinker", "Tinker", machine.startTinkering)
	action.actor = player
	machine.startTinkering(action)
