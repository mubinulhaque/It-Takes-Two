class_name Grabbable
extends CharacterBody3D
## 3D body that can be grabbed by a robot

var grabbed := false
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor() and not grabbed:
		velocity.y -= _gravity * delta
	
	move_and_slide()
