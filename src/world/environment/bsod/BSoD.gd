extends TextureRect

signal bsod_completed()


func start():
	self.visible = true
	$AnimationPlayer.play("crash", -1, 0.25)

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("bsod_completed")
