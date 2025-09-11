class_name Grabbable
extends CharacterBody3D
## 3D body that can be grabbed by a robot

var grabbed := false
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _spawn := Vector3.ZERO


func _ready() -> void:
	_spawn = global_position + Vector3(0, 0.5, 0)


func _physics_process(delta: float) -> void:
	if not is_on_floor() and not grabbed:
		velocity.y -= _gravity * delta
	
	move_and_slide()


func respawn() -> void:
	velocity = Vector3.ZERO
	global_position = _spawn
