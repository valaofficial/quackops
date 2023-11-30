extends Marker3D

@export var ClubDuck: PackedScene
@export var PunchDuck: PackedScene
@export var RifleDuck: PackedScene
@export var PistolDuck: PackedScene

var num_enemies = 1

func _physics_process(_delta):
	if num_enemies:
		var enemy = select_enemy_type(randi_range(1,4)).instantiate()
		var scene_root = $"."
		scene_root.add_child(enemy)
		num_enemies -= 1

func select_enemy_type(index):
	match index:
		1:
			return ClubDuck
		2:
			return PunchDuck
		3:
			return RifleDuck
		4:
			return PistolDuck
		_:
			return PistolDuck
