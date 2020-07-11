extends Area2D

signal end_level
var bodyInside = false

func _ready():
	pass # Replace with function body.



func _on_goal_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		$AnimatedSprite.play("hovered")
		body.hoveringUpdate(true)
		bodyInside = true

func _on_goal_body_exited(body):
	print(body.name)
	if body.is_in_group("player"):
		$AnimatedSprite.play("hovered",true)
		body.hoveringUpdate(false)
		bodyInside = false



func _input(event):
	if bodyInside and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		$AnimatedSprite.play("checked")
		emit_signal("end_level")






