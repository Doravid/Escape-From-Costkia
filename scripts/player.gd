extends CharacterBody3D

var heldObject
var returnParent

@export var sanity := 100

@onready var raycast = $PlayerCamera/objPickupRaycast

var SPEED := 5.0
const JUMP_VELOCITY = 4.5

var mouse_sens := .1

var elapsedTime := 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	

func _process(delta: float) -> void:
	elapsedTime = elapsedTime + delta
	
	if elapsedTime > 1:
		sanity = sanity - 1
	
	if sanity < 0:
		pass
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("sprint"):
		SPEED = 8
	else: 
		SPEED = 5
	
	if Input.is_action_just_pressed("interact"):
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.has_meta("canBePickup"):
				heldObject = target.duplicate()
				returnParent = target.get_parent()
				heldObject.gravity_scale = 0
				heldObject.linear_velocity = Vector3(0, 0, 0)
			
				add_child(heldObject)
				target.queue_free()
			
			
	
	if not heldObject == null:
		heldObject.position = -$PlayerCamera.transform.basis.z * 2
		heldObject.rotation = -Vector3(0, $PlayerCamera.rotation.y, 0)
		
	
	if Input.is_action_just_pressed("throw"):
		if heldObject:
			heldObject.gravity_scale = 1
			remove_child(heldObject)
			returnParent.add_child(heldObject)
			heldObject.position = $".".position + -$".".transform.basis.z * 2
			heldObject.apply_impulse(-$".".transform.basis.z * 20)
			heldObject.apply_impulse(Vector3(0, 4, 0))
			heldObject.wasThrown = true
			heldObject = null
			
	if Input.is_action_just_pressed("drop"):
		if heldObject:
			heldObject.gravity_scale = 1
			remove_child(heldObject)
			returnParent.add_child(heldObject)
			heldObject.position = $".".position + -$".".transform.basis.z * 2
			heldObject.wasThrown = true
			heldObject = null
		
	
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(- event.relative.x * mouse_sens))
			$PlayerCamera.rotate_x(deg_to_rad(- event.relative.y * mouse_sens))
	
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
