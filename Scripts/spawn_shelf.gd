extends Marker3D

@export var block1: PackedScene
@export var block2: PackedScene
@export var block3: PackedScene

# Called when the node enters the scene tree for the first time.
var num_items = 1

func _physics_process(_delta):
	if num_items:
		var Item = get_random_item(randi_range(1,4))
		var item = Item.instantiate()
		var scene_root = $"."
		scene_root.add_child(item)
		num_items -= 1
		
func get_random_item(index):
	match index:
		1:
			return block1
		2:
			return block2
		3:
			return block3
		_:
			return block2
