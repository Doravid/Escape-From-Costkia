extends Area3D

#fetchMeta is either type or item
@export var fetchTypeBool := true

#fetchQuery is either the target type or the target item's name
@export var fetchQuery = "test"

@export var repeatableBool = false

@onready var player = get_node("/root/mainGame/player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if body.has_meta("canBePickup"):
		if fetchTypeBool:
			if body.get_meta("type") == fetchQuery:
				player.sanity = player.sanity + 20
				body.queue_free()
				if not repeatableBool:
					queue_free()
		else:
			if body.name == fetchQuery:
				player.sanity = player.sanity + 40
				body.queue_free()
				if not repeatableBool:
					queue_free()
	
