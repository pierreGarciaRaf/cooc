extends Node2D

var endLevelPopupRes = load("res://src/levelSelector/endLevelPopup.tscn")

export var levelGoalPath : NodePath

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var player = find_node('Cursor')
	print('player', player)
	for hazard in get_tree().get_nodes_in_group('hazard'):
		print('hazard',hazard)
		hazard.connect('hazard_collided', player, 'hazard_collided')
	get_tree().call_group('hazard','start')
	
	if levelGoalPath != null:
		get_node(levelGoalPath).connect("end_level",self,"end_level")



func end_level():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$endGamePopup.popup_centered()
