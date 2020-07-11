extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



func _on_Cursor_body_entered(body):
	print('body')



