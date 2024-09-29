extends Node3D

@onready var navBod = $NavAgent
@onready var rigBod = $RigidBody3D
@onready var sprite = $Sprite3D

@onready var activeBod = navBod

var countdown = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rigBod.WasHit:
		activeBod = rigBod
	else:
		activeBod = navBod
	
	
	
	if activeBod == navBod:
		navBod.set_collision_layer_value(1, true)
		navBod.set_collision_layer_value(2, true)
		navBod.set_collision_mask_value(1, true)
		navBod.set_collision_mask_value(2, true)
		rigBod.set_collision_layer_value(2, false)
		rigBod.set_collision_mask_value(1, false)
		rigBod.position = navBod.position 
		sprite.position = navBod.position + Vector3.UP * 1
	
	if  activeBod == rigBod:
		navBod.set_collision_layer_value(1, false)
		navBod.set_collision_layer_value(2, false)
		navBod.set_collision_mask_value(1, false)
		navBod.set_collision_mask_value(2, false)
		rigBod.set_collision_layer_value(2, true)
		rigBod.set_collision_mask_value(2, true)
		rigBod.set_collision_mask_value(1, true)
		navBod.position = rigBod.position
		sprite.position = rigBod.position + Vector3.UP * 1
		sprite.rotation = rigBod.rotation
