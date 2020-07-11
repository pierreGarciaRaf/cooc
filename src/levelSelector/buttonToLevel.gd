extends Button

var levelPath
func get_level_path():
	return "res://src/levels/orderedLevels/level" + (self.name as String).trim_prefix("buttonToLevel") + ".tscn"

func _ready():
	levelPath = get_level_path()
	print(levelPath)



func _on_buttonToLevel_pressed():
	get_tree().change_scene_to(load(levelPath))
