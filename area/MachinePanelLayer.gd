extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	AreaEvent.modalPanelOpened.connect(modalPanelOpened)

func modalPanelOpened(modal):
	add_child(modal)
