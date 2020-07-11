extends KinematicBody2D



var velocity = Vector2()

var lastMousePos = Vector2(0,0)

func get_input():
	#removes the tp bug
	var newMousePos = get_viewport().get_mouse_position()
	velocity = newMousePos - lastMousePos
	lastMousePos = newMousePos


func _physics_process(delta):
	get_input()
	move_and_slide(velocity/delta)

	if get_slide_count()>0 :
		#print (collision, collision.collider)
		$Sprite.modulate = Color(1,0,0,1)
	else:
		$Sprite.modulate = Color(1,1,1,1)
