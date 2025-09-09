extends CharacterBody3D

## Movement speed of the robot
const _MOVE_SPEED := 5
## Turning speed of the robot
const _TURN_SPEED := 5


func _physics_process(delta: float) -> void:
	# Moving forward
	var _input_dir := (transform.basis * Vector3(
			0,
			0,
			Input.get_axis("ui_up", "ui_down")
	)).normalized()
	
	if _input_dir:
		velocity.x = _input_dir.x * _MOVE_SPEED
		velocity.z = _input_dir.z * _MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, _MOVE_SPEED)
		velocity.z = move_toward(velocity.z, 0, _MOVE_SPEED)
	
	# Turning
	rotate_y(Input.get_axis("ui_right", "ui_left") * _TURN_SPEED * delta)
	
	move_and_slide()
