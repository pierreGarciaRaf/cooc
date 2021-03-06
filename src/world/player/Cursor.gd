extends KinematicBody2D


var Warning = load("res://src/world/environment/warning/Warning.tscn")

var mouseMoveBetweenProcess =  Vector2.ZERO
var velocity = Vector2()
var hazard_velocity = Vector2()

var pushVelocity = Vector2()

var lastMousePos = Vector2(0,0)

var lifePointPull = 3
var lifePoint

var lastDmgCursorPos = Vector2.ZERO

var canReceiveDamage = true setget setCanReceiveDamage


signal die()

func _ready():
	hoveringUpdate(false)
	lifePoint = lifePointPull

func _input(event):
	#so the mouse is captured
	if event is InputEventMouseMotion:
		mouseMoveBetweenProcess += (event as InputEventMouseMotion).relative

func get_input():
	#removes the teleportation bug + allows the mouse to move while it's captured
	velocity = mouseMoveBetweenProcess
	mouseMoveBetweenProcess = Vector2.ZERO



func updateCanReceiveDamage():
	#anti fast mouse movement
	if not canReceiveDamage:
		if (self.position - lastDmgCursorPos).length() > 8*4*4:
			setCanReceiveDamage(true)

func playDamage():
	$damagePlayer.pitch_scale = 1.5*randf()+0.20
	$damagePlayer.play(0)

func _physics_process(delta):
	get_input()
	move_and_slide(velocity/delta+hazard_velocity + pushVelocity)
	updateCanReceiveDamage()
	hazard_velocity = Vector2.ZERO
	pushVelocity /= 1.1
	if get_slide_count()>0 :
		#print (collision, collision.collider)
		for slideIndex in range(get_slide_count()):
			var collider = get_slide_collision(slideIndex).collider
			if collider.is_in_group("damage_on_contact"):
				modulateSprites(Color(1,0,0,1))
				playDamage()
				if canReceiveDamage:
					receiveDamage()
				pushOnContact(get_slide_collision(slideIndex).normal*800)
			elif collider.is_in_group("bump_on_contact"):
				pushOnContact(get_slide_collision(slideIndex).normal*500)

func modulateSprites(color):
	$arrow.modulate = color
	$hand.modulate = color

func pushOnContact(toBePushedBack):
	pushVelocity = toBePushedBack


func receiveDamage():
	lastDmgCursorPos = self.position
	print("receiveDamage")
	lifePoint -= 1
	update_life_bar()
	setCanReceiveDamage(false)
	if lifePoint == 0:
		$deathPlayer.play(0)
		die()

func setCanReceiveDamage(toSet):
	canReceiveDamage = toSet
	modulateSprites(Color(1,1,1,1) if canReceiveDamage else Color(1,0,0,1))
	if not canReceiveDamage:
		var warning = Warning.instance()
		warning.position = self.global_position
		get_parent().add_child(warning)
		
		warning.connect('warning_disappeared',self,'warning_disappeared')
		warning.start()

func warning_disappeared():
	setCanReceiveDamage(true)


func die():
	emit_signal("die")

func hazard_collided(velocity_param):
	hazard_velocity+=velocity_param

func update_life_bar():
	(get_node("CanvasLayer/crit" + String(lifePoint+1)) as TextureRect).texture = load("res://src/world/player/critical.png")


func hoveringUpdate(isHovering):
	$arrow.visible = !isHovering
	$hand.visible = isHovering
