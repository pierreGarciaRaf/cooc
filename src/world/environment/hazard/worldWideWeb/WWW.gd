extends Node2D
tool


signal hazard_collided(velocity) 

export (float) var radius = 100
export (float) var duration = 20
export var gravity_intensity = 10

enum State {
	IDLE,
	BLOWING_ON,
	BLOWING,
	BLOWING_OFF
}


const FOREVER = true

func _ready():
	$air/CollisionShape2D.shape.radius = radius
	$Timer.wait_time = duration
	start()
	# Setup particle material to reflect air area2D
	var pmaterial = $Particles2D.process_material.duplicate(true)
	$Particles2D.process_material = pmaterial
	$Particles2D.lifetime = radius * 2 / pmaterial.initial_velocity
	$Particles2D.amount = abs(gravity_intensity)
	$Particles2D.process_material.emission_sphere_radius = radius
	change_state(State.IDLE)

func _process(_delta):
	if entered_body and state != State.IDLE:
		var body_position = to_local(entered_body.global_position)
		var r = body_position.length()
		var v = - gravity_intensity * 1000 * body_position/(r*r)
		emit_signal("hazard_collided", v)

func change_state(new_state):
	state = new_state
	match state:
		State.IDLE:
			$air.space_override =Area2D.SPACE_OVERRIDE_DISABLED
		State.BLOWING_ON:
			$Particles2D.restart()
			$Particles2D.emitting=true
			$Particles2D.visible = true
			#$air.space_override = Area2D.SPACE_OVERRIDE_REPLACE
		State.BLOWING:
			$Timer.start()
		State.BLOWING_OFF:
			$Particles2D.visible = false
			$Particles2D.emitting=false
		

func _on_Timer_timeout():
	if not FOREVER:
		change_state(State.BLOWING_OFF)

func _on_blow_animation_finished():
	match state:
		State.BLOWING_ON:
			change_state(State.BLOWING)
		State.BLOWING_OFF:
			change_state(State.IDLE)


func start():
	if state != State.IDLE:
		return
	change_state(State.BLOWING_ON)

func _on_AnimationPlayer_animation_finished(_anim_name):
	_on_blow_animation_finished()

# Abstract function to play animation (AnimatedSprite or AnimationPlayer)
func play_animation(anim_name):
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
			

var state
var entered_body

func _on_air_body_entered(body):
	if body.is_in_group('player'):
		entered_body = body


func _on_air_body_exited(body):
	if body.is_in_group('player'):
		entered_body = null

