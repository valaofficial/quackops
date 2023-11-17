extends Marker3D

@export var Enemy: PackedScene

var num_enemies = 1

func _physics_process(_delta):
	if num_enemies:
		var enemy = Enemy.instantiate()
		var scene_root = $"."
		scene_root.add_child(enemy)
		num_enemies -= 1

