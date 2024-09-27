extends CharacterBody3D


const SPEED = 5.0
const ACCELERATION = 10

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	
	var direction = Vector3()
	
	nav.target_position = $"../TargetPos".position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
	
	move_and_slide()
