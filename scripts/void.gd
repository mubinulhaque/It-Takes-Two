extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


## When something enters the void (i.e. has fallen too far downwards)
func _on_body_entered(body: Node3D) -> void:
	if body is Grabbable:
		body.respawn()
