extends Node3D

@export var speed: int
@export var damage = 1

const KILL_TIME = 3
var timer = 0
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var bullet_forward_direction = global_transform.basis.z.normalized()
	global_translate(bullet_forward_direction * speed * delta)
	
	timer += delta
	if timer > KILL_TIME:
		queue_free()


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		print("Player Hit")
#		body.take_damage(damage)
	if !body.is_in_group("Enemies"):
		queue_free()	
