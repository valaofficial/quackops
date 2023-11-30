extends CharacterBody3D

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var timer = $Timer


@export var acceleration: float = 10
@export var enemy_bullet: PackedScene
@export var muzzle_speed = 20

var enemy_hp
var speed
var can_shoot = true
var is_attacking = false

func _ready():
	speed = set_enemy_speed()
	call_deferred("getnav")
	if is_in_group("ShooterEnemy"):
		timer.wait_time = set_enemy_firerate()
	enemy_hp = set_enemy_health()

func _physics_process(_delta):
	var player_position = player.global_position
	$".".look_at(Vector3(player_position.x, $".".global_position.y, player_position.z), Vector3(0,1,0))
	
	var direction = Vector3()
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	var new_velocity = direction * Vector3(randi_range(1,2), 0, randi_range(1,2)) * speed
	
	
	if is_in_group("ShooterEnemy"):
		if global_position.distance_to(player_position) <= 5:
			new_velocity = direction * Vector3(randi_range(1,2), 0, randi_range(1,2)) * speed * -1	
			
			if is_in_group("PistolDuck"):
				$AnimationPlayer.play("pistolwalkback")
				
			if is_in_group("RifleDuck"):
				$AnimationPlayer.play_backwards("riflerun")
				
		elif  global_position.distance_to(player_position) <= 10:
			new_velocity = Vector3.ZERO
			shoot()
			
		if is_in_group("PistolDuck"):
			if velocity != Vector3.ZERO:
				$AnimationPlayer.play("pistolwalk")
				
		if is_in_group("RifleDuck"):
			if velocity != Vector3.ZERO:
				$AnimationPlayer.play("riflerun")
			
	if is_in_group("MeleeEnemy"):
		if velocity != Vector3.ZERO:
			$AnimationPlayer.play("run")
			
		if global_position.distance_to(player_position) < 2:
			new_velocity = Vector3.ZERO
			attack()
			
	if is_in_group("ClubDuck"):
		if velocity != Vector3.ZERO:
			$AnimationPlayer.play("run")
			
		if global_position.distance_to(player_position) < 2:
			new_velocity = Vector3.ZERO
			attack()
	
			
	nav.set_velocity(new_velocity)	
		
	getnav()
	move_and_slide()

func getnav():
	nav.target_position = player.global_position

func take_damage(damage):
	if enemy_hp:
		enemy_hp -= damage

	if enemy_hp <= 0:
		die()

func die():
	queue_free()
	

func shoot():
	if can_shoot:
		if velocity == Vector3.ZERO:
			if is_in_group("PistolDuck"):
				$AnimationPlayer.play("pistolstand")
			else:
				$AnimationPlayer.play("riflestand")
		else:
			if is_in_group("PistolDuck"):
				$AnimationPlayer.play("pistolwalk")
			else:
				$AnimationPlayer.play("riflerun")
		var new_bullet = enemy_bullet.instantiate()
		new_bullet.speed = muzzle_speed
		new_bullet.global_transform = $Body/Muzzle.global_transform
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		can_shoot = false
		timer.start()

func attack():
	is_attacking = true
	if is_in_group("ClubDuck"):
		$AnimationPlayer.play("heavymelee")
	elif is_in_group("MeleeEnemy"):	
		$AnimationPlayer.play("punch")

func set_enemy_speed():
	if is_in_group("MeleeEnemy"):
		return 2
	elif is_in_group("ShooterEnemy"):
		return 3
	elif is_in_group("ClubDuck"):
		return 1

func set_enemy_health():
	if is_in_group("MeleeEnemy"):
		return 5
	elif is_in_group("ShooterEnemy"):
		return 3
	elif is_in_group("ClubDuck"):
		return 8

func set_enemy_firerate():
	if is_in_group("PistolDuck"):
		return 1.35
	elif is_in_group("RifleDuck"):
		return .25

#Signals
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)

func _on_timer_timeout():
	can_shoot = true


func _on_hit_box_body_entered(body):
	if is_attacking:
		if body.is_in_group("Player"):
			print(body)
