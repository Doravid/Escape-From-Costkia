extends CharacterBody3D


const SPEED = 3.5
const ACCELERATION = 10

var waitBool := true

var searchTarget

@onready var target = get_node("/root/mainGame/waypoints").get_child(randi_range(0, get_node("/root/mainGame/waypoints").get_child_count() - 1))

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _process(delta: float) -> void:
	await get_tree().process_frame
	
	
	if target.position.distance_to($".".position) < 10 and waitBool:
		wait()
		waitBool = false
	
	if get_parent().find_child("RigidBody3D").mode == "roam":
		searchTarget = target
	else:
		if get_parent().find_child("RigidBody3D").mode == "pursuit":
			searchTarget = get_node("/root/mainGame/player")

func wait():
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = randi_range(5, 10)
	timer.start()
	await timer.timeout
	waitBool = true
	target = get_node("/root/mainGame/waypoints").get_child(randi_range(0, get_node("/root/mainGame/waypoints").get_child_count() - 1))

func _physics_process(delta):
	await get_tree().process_frame
	
	var direction = Vector3()
	
	nav.target_position = target.position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
	
	move_and_slide()
