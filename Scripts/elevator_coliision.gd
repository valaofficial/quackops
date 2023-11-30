extends Node3D

@export var scene1 = "res://Scenes/level2.tscn"
@export var scene2 = "res://Scenes/level4.tscn"
@export var scene3 = "res://Scenes/level5.tscn"
@export var scene4 = "res://Scenes/level6.tscn"
@export var scene5 = "res://Scenes/level.tscn"
@export var scene6 = "res://Scenes/level_3.tscn"


func get_random_scene(index):
	match index:
		1:
			return scene1
		2:
			return scene2
		3:
			return scene3
		4:
			return scene4
		5:
			return scene5
		6:
			return scene6
		_:
			return scene1

func select_random_scene():
	var next_scene = get_random_scene(randi_range(1,6))
	return next_scene


func _on_area_3d_body_entered(body):
	if WorldControl.AllEnemiesKilled == true:
		var current_scene = get_tree().current_scene.scene_file_path
		if body.is_in_group("Player"):
			var next_scene = select_random_scene()
			if next_scene == current_scene:
				next_scene = select_random_scene()
				get_tree().change_scene_to_file(next_scene)
			else:
				get_tree().change_scene_to_file(next_scene)
			
