extends CharacterBody3D

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var timer = $Timer

@export var speed: float = 8
@export var acceleration: float = 10
@export var max_HP = 3
@export var enemy_bullet: PackedScene
@export var muzzle_speed = 20
@export var time_btw_shots = 1

var current_hp
var can_shoot = true

func _ready():
	call_deferred("getnav")
	timer.wait_time = time_btw_shots
	current_hp = max_HP

func _physics_process(_delta):
	var player_position = player.global_position
	$".".look_at(Vector3(player_position.x, $".".global_position.y, player_position.z), Vector3(0,1,0))
	
	var direction = Vector3()
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	var new_velocity = direction * Vector3(randi_range(1,2), 0, randi_range(1,2)) * speed
	
	if global_position.distance_to(player_position) <= 5:
		new_velocity = direction * Vector3(randi_range(1,2), 0, randi_range(1,2)) * -(speed/2.0)
	
#	velocity = velocity.move_toward(new_velocity, 10)
	nav.set_velocity(new_velocity)	
	
	if global_position.distance_to(player_position) <= 10:
		shoot()
	
	getnav()
	move_and_slide()

func getnav():
	nav.target_position = player.global_position

func take_damage(damage):
	if current_hp:
		current_hp -= damage

	if current_hp <= 0:
		die()

func die():
	queue_free()
	

func shoot():
	if can_shoot:
		var new_bullet = enemy_bullet.instantiate()
		new_bullet.speed = muzzle_speed
		new_bullet.global_transform = $Body/Muzzle.global_transform
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		can_shoot = false
		timer.start()


#Signals
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)

func _on_timer_timeout():
	can_shoot = true
