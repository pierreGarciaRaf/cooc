extends Node2D

var endLevelPopupRes = load("res://src/levelSelector/endLevelPopup.tscn")

export var levelGoalPath : NodePath



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Refresh.start()
	if levelGoalPath != null:
		get_node(levelGoalPath).connect("end_level",self,"end_level")



func end_level():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$endGamePopup.popup_centered()
