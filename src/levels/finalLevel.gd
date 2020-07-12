extends "res://src/levels/levelScript.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	find_node("goal").connect("end_game",self,"end_game")


func end_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$finalGamePopup.popup_centered()
