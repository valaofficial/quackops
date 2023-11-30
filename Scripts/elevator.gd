extends Node3D

@export var scene1 = "res://Scenes/level2.tscn"
@export var scene2 = "res://Scenes/level4.tscn"
@export var scene3 = "res://Scenes/level5.tscn"
@export var scene4 = "res://Scenes/level6.tscn"
@export var scene5 = "res://Scenes/level.tscn"
@export var scene6 = "res://Scenes/level_3.tscn"

var is_open = false

func _physics_process(_delta):
	if WorldControl.AllEnemiesKilled:
		open_elevator()
	
	if !WorldControl.AllEnemiesKilled:
		close_elevator()

func close_elevator():
		if is_open:
			$AnimationPlayer.play("close")
			is_open = false

func open_elevator():
		if !is_open:
			$AnimationPlayer.play("open")
			is_open = true
	
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
	close_elevator()
	if !is_open:
		if WorldControl.AllEnemiesKilled == true:
			var current_scene = get_tree().current_scene.scene_file_path
			if body.is_in_group("Player"):
				var next_scene = select_random_scene()
				if next_scene == current_scene:
					next_scene = select_random_scene()
					get_tree().change_scene_to_file(next_scene)
				else:
					get_tree().change_scene_to_file(next_scene)
			




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "close":
		is_open = false
	
	if anim_name == "open":
		is_open = true
