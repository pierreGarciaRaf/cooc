extends Node2D
tool

export (Shape2D) onready var AIR_SHAPE setget set_air_shape

export var gravity_intensity = -40

enum State {
	IDLE,
	BLOWING_ON,
	BLOWING,
	BLOWING_OFF
}

func set_air_shape(air_shape):
	if Engine.editor_hint and air_shape and is_inside_tree():
		setup_air_shape(air_shape)
		$air.update()
	AIR_SHAPE=air_shape


func get_air_shape():
	return AIR_SHAPE

var shift_y = - 140; # something like sprite.height/2

func animate_area():
	var shape = AIR_SHAPE.duplicate()
	$air/CollisionShape2D.shape=shape
	$air.update()
	
	var duration = AIR_SHAPE.extents.y * 2 / $Particles2D.process_material.initial_velocity / $Particles2D.speed_scale
	$Tween.interpolate_property(shape,"extents",
			Vector2(AIR_SHAPE.extents.x, 0),
			AIR_SHAPE.extents, 
			duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($air/CollisionShape2D,"position",
			Vector2(0, shift_y),
			Vector2(0, shift_y - AIR_SHAPE.get_extents().y), 
			duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()	


func setup_air_shape(air_shape):
	$air/CollisionShape2D.position = Vector2(0, shift_y - air_shape.get_extents().y)
	$air/CollisionShape2D.shape=air_shape
	
func _ready():
	# Gravity 
	var gravity_angle = self.rotation + PI/2
	
	# Air area2D
	$air.gravity_vec = Vector2(cos(gravity_angle), sin(gravity_angle))*gravity_intensity
	setup_air_shape(AIR_SHAPE)
	var air_extents = $air/CollisionShape2D.shape.get_extents()
	
	# Setup particle material to reflect air area2D
	var pmaterial = $Particles2D.process_material.duplicate(true)
	pmaterial.emission_box_extents = Vector3(air_extents.x, 1,1)
	$Particles2D.position = Vector2.ZERO
	$Particles2D.process_material = pmaterial
	$Particles2D.lifetime = air_extents.y * 2 / pmaterial.initial_velocity
	$Particles2D.amount = 5 * abs(gravity_intensity)
	
	if gravity_intensity > 0: 
		$Particles2D.scale = Vector2(1,-1)
		$Particles2D.position -= 2*Vector2(0,air_extents.y)
		$Particles2D.preprocess = $Particles2D.lifetime
	else:
		$Particles2D.scale = Vector2(1,1)
		#$Particles2D.position = Vector2(0, -70 - air_extents.y*2)
		$Particles2D.preprocess = 0
	

	change_state(State.IDLE)

func change_state(new_state):
	state = new_state
	match state:
		State.IDLE:
			$air.space_override =Area2D.SPACE_OVERRIDE_DISABLED
		State.BLOWING_ON:
			$Particles2D.restart()
			$Particles2D.emitting=true
			$Particles2D.visible = true
			$air.space_override = Area2D.SPACE_OVERRIDE_REPLACE
			if gravity_intensity < 0:
				animate_area()
			play_animation('blowing_on')
		State.BLOWING:
			$Timer.start()
			play_animation('blowing')
		State.BLOWING_OFF:
			$Particles2D.visible = false	
			$Particles2D.emitting=false
			$air.space_override = Area2D.SPACE_OVERRIDE_DISABLED
			play_animation('blowing_off')
		

func _on_Timer_timeout():
	change_state(State.BLOWING_OFF)

func _on_pipe_animation_finished():
	match state:
		State.BLOWING_ON:
			change_state(State.BLOWING)
		State.BLOWING_OFF:
			change_state(State.IDLE)

func _on_Pipe_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		start()

func start():
	if state != State.IDLE:
		return
	change_state(State.BLOWING_ON)

func _on_AnimationPlayer_animation_finished(_anim_name):
	_on_pipe_animation_finished()

# Abstract function to play animation (AnimatedSprite or AnimationPlayer)
func play_animation(	anim_name):
	var backward = gravity_intensity > 0
	if backward:
		if has_node(@"AnimationPlayer"):
			$AnimationPlayer.play_backwards(anim_name)
		else:
			$Sprite.play(anim_name,true)
	else:
		if has_node(@"AnimationPlayer"):
			$AnimationPlayer.play(anim_name)
		else:
			$Sprite.play(anim_name)
			

var glow_material
var state
