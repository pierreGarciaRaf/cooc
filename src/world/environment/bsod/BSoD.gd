extends TextureRect

signal bsod_completed()


func _ready():
	$AnimationPlayer.play("crash", -1, 0.25)


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("bsod_completed")
