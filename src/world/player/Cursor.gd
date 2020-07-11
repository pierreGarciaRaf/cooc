extends KinematicBody2D



var mouseMoveBetweenProcess =  Vector2.ZERO
var velocity = Vector2()
var hazard_velocity = Vector2()

var pushVelocity = Vector2()

var lastMousePos = Vector2(0,0)

var lifePointPull = 3
var lifePoint

var canReceiveDamage = true setget setCanReceiveDamage




func _ready():
	$CanvasLayer/toReplaceWithSomethingNice.max_value = lifePointPull
	lifePoint = lifePointPull

func _input(event):
	#so the mouse is captured
	if event is InputEventMouseMotion:
		mouseMoveBetweenProcess += (event as InputEventMouseMotion).relative

func get_input():
	#removes the teleportation bug + allows the mouse to move while it's captured
	velocity = mouseMoveBetweenProcess
	mouseMoveBetweenProcess = Vector2.ZERO



func _physics_process(delta):
	get_input()
	move_and_slide(velocity/delta+hazard_velocity + pushVelocity)
	hazard_velocity = Vector2.ZERO
	pushVelocity /= 1.1
	if get_slide_count()>0 :
		#print (collision, collision.collider)
		for slideIndex in range(get_slide_count()):
			var collider = get_slide_collision(slideIndex).collider
			if collider.is_in_group("damage_on_contact"):
				$Sprite.modulate = Color(1,0,0,1)
				if canReceiveDamage:
					receiveDamage()
				pushOnContact(get_slide_collision(slideIndex).normal*800)
			elif collider.is_in_group("bump_on_contact"):
				pushOnContact(get_slide_collision(slideIndex).normal*500)

func pushOnContact(toBePushedBack):
	pushVelocity = toBePushedBack

func receiveDamage():
	print("receiveDamage")
	lifePoint -= 1
	update_life_bar()
	setCanReceiveDamage(false)
	if lifePoint == 0:
		die()

func setCanReceiveDamage(toSet):
	canReceiveDamage = toSet
	$Sprite.modulate = Color(1,1,1,1) if canReceiveDamage else Color(1,0,0,1)
	if not canReceiveDamage:
		$damageTimer.start()

func die():
	pass

func _hazard_action(velocity_param):
	hazard_velocity+=velocity_param

func update_life_bar():
	$CanvasLayer/toReplaceWithSomethingNice.value = lifePoint


func _on_damageTimer_timeout():
	setCanReceiveDamage(true)
