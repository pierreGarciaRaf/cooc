extends KinematicBody2D



var mouseMoveBetweenProcess =  Vector2.ZERO
var velocity = Vector2()
var hazard_velocity = Vector2()

var lastMousePos = Vector2(0,0)

func _input(event):
	#so the mouse is captured
	if event is InputEventMouseMotion:
		mouseMoveBetweenProcess += (event as InputEventMouseMotion).relative

func get_input():
	#removes the tp bug + allows the mouse to move while it's captured
	velocity = mouseMoveBetweenProcess
	mouseMoveBetweenProcess = Vector2.ZERO


func _physics_process(delta):
	get_input()
	move_and_slide((velocity+hazard_velocity)/delta)
	hazard_velocity = Vector2.ZERO
	if get_slide_count()>0 :
		#print (collision, collision.collider)
		$Sprite.modulate = Color(1,0,0,1)
	else:
		$Sprite.modulate = Color(1,1,1,1)


func _on_Refresh_hazard_collided(velocity):
	hazard_velocity+=velocity
