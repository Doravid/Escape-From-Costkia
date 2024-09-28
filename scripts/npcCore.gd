extends RigidBody3D

@export var hatred := 0

@export var timesWronged := 0

@export var mode := "roam"

var timeToWait := 0


@onready var player = get_node("/root/mainGame/player")

@onready var lastPlayerPos = player.position

var timeElapsed := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$RayCast3D.target_position = player.position
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider() == player:
			lastPlayerPos = player.position
	



func _on_body_entered(body: Node) -> void:
	if body.has_meta("canBePickup"):
		if body.wasThrown: 
			timesWronged = timesWronged + 1
			hatred = timesWronged * 10
			player.sanity = player.sanity + hatred
			mode = "pursuit"
			$Timer.wait_time = hatred
			$Timer.start()
			await $Timer.timeout
			mode = "roam"
			hatred = 0
