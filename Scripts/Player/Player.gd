extends CharacterBody3D


@export var speed = 10
@export var dash_speed = 15
@export var player_bullet: PackedScene
@export var muzzle_speed = 40
@export var time_btw_shots = .1
@export var time_btw_dash = .5


@onready var shots_timer = $Timer
@onready var dash_timer = $DashTimer
@onready var camera = get_tree().get_nodes_in_group("Camera")[0]


var ray_origin = Vector3.ZERO
var ray_target = Vector3.ZERO

var defaut_speed
var can_shoot = true
var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func  _ready():
	defaut_speed = speed
	shots_timer.wait_time = time_btw_shots
	dash_timer.wait_time = time_btw_dash

func _physics_process(delta):
	camera.global_position.x = clamp(camera.global_position.x, -3.0, 3)
	camera.global_position.z = clamp(camera.global_position.z, 8, 12)
	#Getting Player to Look at the mouse
	#Get the mouse position in the world
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_target = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	
	var intersect_params = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
	var intersection = space_state.intersect_ray(intersect_params)
	
	if not intersection.is_empty():
		var pos = intersection.position
		$Body.look_at(Vector3(pos.x, $Body.global_position.y , pos.z), Vector3(0,1,0))
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("dash"):
		if can_dash:
			defaut_speed = dash_speed
			can_dash = false
			dash_timer.start()
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * defaut_speed
		velocity.z = direction.z * defaut_speed
	else:
		velocity.x = move_toward(velocity.x, 0, defaut_speed)
		velocity.z = move_toward(velocity.z, 0, defaut_speed)

	handle_inputs()
	
	move_and_slide()
	
func handle_inputs():
	if Input.is_action_pressed("attack"):
		shoot()

func shoot():
	if can_shoot:
		var new_bullet = player_bullet.instantiate()
		new_bullet.speed = muzzle_speed
		new_bullet.global_transform = $Body/Muzzle.global_transform
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		can_shoot = false
		shots_timer.start()


func _on_timer_timeout():
	can_shoot = true


func _on_dash_timer_timeout():
	defaut_speed = speed
	can_dash = true
