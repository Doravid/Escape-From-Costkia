extends RigidBody3D

@export var hatred := 0

@export var timesWronged := 0

@export var mode := "roam"

var timeToWait := 0

var WasHit := false

@onready var player = get_node("/root/mainGame/player")

@onready var lastPlayerPos = player.position

var timeElapsed := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$RayCast3D.target_position = player.position
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider() == player:
			lastPlayerPos = player.position
			
	if WasHit and timeElapsed > 0:
		timeElapsed = timeElapsed - 1
	else:
		if not isStandingBool():
			angular_velocity = Vector3.ZERO
			standUp(delta)
		else:
			WasHit = false
		
	
	
	



func _on_body_entered(body: Node) -> void:
	if body.has_meta("canBePickup"):
		if body.wasThrown: 
			WasHit = true
			timeElapsed = 500
			apply_impulse(Vector3.UP * 20)
			timesWronged = timesWronged + 1
			hatred = timesWronged * 10
			player.sanity = player.sanity + hatred
			mode = "pursuit"
			$aggroTimer.wait_time = hatred
			$aggroTimer.start()
			await $aggroTimer.timeout
			mode = "roam"
			hatred = 0

var uprightThreshold := .999

func isStandingBool():
	return transform.basis.y.normalized().dot(Vector3.UP) > uprightThreshold

var torqueStrength := .001
var smoothing := .1

func standUp(delta):
	transform.basis.x = Vector3(1,0,0) * smoothing + transform.basis.x * (1 - smoothing)
	transform.basis.y = Vector3(0,1,0) * smoothing + transform.basis.y * (1 - smoothing)
	transform.basis.z = Vector3(0,0,1) * smoothing + transform.basis.z * (1 - smoothing)
