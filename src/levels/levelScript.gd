extends Node2D



export var levelGoalPath : NodePath

var Crt = load('res://src/world/environment/crt/CRT.tscn')

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var player = find_node('Cursor')
	print('player', player)
	for hazard in get_tree().get_nodes_in_group('hazard'):
		print('hazard',hazard)
		hazard.connect('hazard_collided', player, 'hazard_collided')
	get_tree().call_group('hazard','start')
	
	get_tree().get_nodes_in_group('player')[0].connect("die",self,"player_dies")
	
	if levelGoalPath != null:
		find_node("goal").connect("end_level",self,"end_level")
		
	self.add_child(Crt.instance())


func end_level():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$endGamePopup.popup_centered()

func player_dies():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	print('died')
	$deathPopup.popup_centered()
