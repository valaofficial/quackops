extends Node3D

#Tables
@export var table1: PackedScene = preload("res://Scenes/Environment/Furniture/table_2.tscn")
@export var table2: PackedScene = preload("res://Scenes/Environment/Furniture/table_3.tscn")
@export var table3: PackedScene = preload("res://Scenes/Environment/Furniture/table_5.tscn")

#Shelves
@export var shelf1: PackedScene = preload("res://Scenes/Environment/Furniture/Shelves/book_shelf_1.tscn")
@export var shelf2: PackedScene = preload("res://Scenes/Environment/Furniture/Shelves/book_shelf_2.tscn")
@export var shelf3: PackedScene = preload("res://Scenes/Environment/Furniture/Shelves/counter1.tscn")
@export var shelf4: PackedScene = preload("res://Scenes/Environment/Furniture/Shelves/counter2.tscn")

#Extra Items
@export var item1: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/bin.tscn")
@export var item2: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/binsmall.tscn")
@export var item3: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/canvas.tscn")
@export var item4: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/cofeemachine.tscn")
@export var item5: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/large_filing_cabinet.tscn")
@export var item6: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/microwave.tscn")
@export var item7: PackedScene = preload("res://Scenes/Environment/Furniture/Extras/small_filing_cabinet.tscn")


var spawn_tables_complete = false
var spawn_shelves_complete = false
var spawn_extras_complete = false
var level_enemies

func _ready():
	spawn_tables()
	spawn_extras()
	spawn_shelves()
	
#Baking navmesh after furnitures are spawned
	if spawn_tables_complete && spawn_shelves_complete && spawn_extras_complete:
		$NavigationRegion3D.bake_navigation_mesh()

func _physics_process(_delta):
	level_enemies = get_tree().get_nodes_in_group("Enemies")
	if level_enemies.size() <= 0:
		WorldControl.AllEnemiesKilled = true
	else:
		WorldControl.AllEnemiesKilled = false

#Spawning Tables
func spawn_tables():
	var tableSpawners = get_tree().get_nodes_in_group("TableSpawnPoints")
	var num_tables = tableSpawners.size()
	for i in tableSpawners.size():
		var Item = get_random_table(randi_range(1,5))
		var item = Item.instantiate()
		var scene_root = tableSpawners[i]
		scene_root.add_child(item)
		num_tables -= 1
		
	if !num_tables:
		spawn_tables_complete = true

#Spawning Extras
func spawn_extras():
	var extrasSpawners = get_tree().get_nodes_in_group("ExtrasSpawnPoints")
	var num_extras = extrasSpawners.size()
	for i in extrasSpawners.size():
		var Item = get_random_item(randi_range(1,7))
		var item = Item.instantiate()
		var scene_root = extrasSpawners[i]
		scene_root.add_child(item)
		num_extras -= 1
	
	if !num_extras:
		spawn_extras_complete = true


#Spawning Shelves
func spawn_shelves():
	var shelvesSpawners = get_tree().get_nodes_in_group("ShelfSpawnPoints")
	var num_shelves = shelvesSpawners.size()
	for i in shelvesSpawners.size():
		var Item = get_random_shelf(randi_range(1,4))
		var item = Item.instantiate()
		var scene_root = shelvesSpawners[i]
		scene_root.add_child(item)
		num_shelves -= 1
	
	if !num_shelves:
		spawn_shelves_complete = true
	
	

#Get random table
func get_random_table(index):
	match index:
		1:
			return table1
		2:
			return table2
		3:
			return table3
		_:
			return table3

#Get random Extra Item
func get_random_item(index):
	match index:
		1:
			return item1
		2:
			return item2
		3:
			return item3
		4:
			return item4
		5:
			return item5
		6:
			return item6
		7:
			return item7

#Get random shelf
func get_random_shelf(index):
	match index:
		1:
			return shelf1
		2:
			return shelf2
		3:
			return shelf3
		4:
			return shelf4


