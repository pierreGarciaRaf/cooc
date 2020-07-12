extends "res://src/world/environment/goal/goal.gd"

signal end_game

func _input(event):
	if not alreadyPressed and bodyInside and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		alreadyPressed = true
		$AnimatedSprite.play("checked")
		$AudioStreamPlayer.play(0)
		emit_signal("end_game")
