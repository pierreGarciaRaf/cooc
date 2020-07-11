extends Area2D

signal end_level

func _ready():
	pass # Replace with function body.



func _on_goal_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		print("player in")
		emit_signal("end_level")
