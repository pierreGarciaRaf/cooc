extends Sprite

signal warning_disappeared()

var speed = 500
var b = 0.75
var direction

func start():
	$AnimationPlayer.play("go")
	direction = Vector2(rand_range(-1,1),rand_range(-1,1))


func _process(delta):
	self.position+= delta*speed*(b*direction + (1-b)*Vector2(rand_range(-1,1),rand_range(-1,1)))

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal('warning_disappeared')
	self.queue_free()
