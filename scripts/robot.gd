extends CharacterBody3D

## Movement speed of the robot
const _MOVE_SPEED := 5
## Turning speed of the robot
const _TURN_SPEED := 5

@export var forwards: String = "ui_up"
@export var backwards: String = "ui_down"
@export var left: String = "ui_left"
@export var right: String = "ui_right"
@export var grab: String = "ui_accept"

## Bodies that can be grabbed by the robot
var _grabbables: Array[Grabbable]
## Body that is currently grabbed by the robot
var _grabbed: Grabbable

@onready var _grab_area: Area3D = $GrabArea
@onready var _grab_transform: RemoteTransform3D = $GrabArea/GrabTransform


func _physics_process(delta: float) -> void:
	# Moving forward
	var _input_dir := (transform.basis * Vector3(
			0,
			0,
			Input.get_axis(forwards, backwards)
	)).normalized()
	
	if _input_dir:
		velocity.x = _input_dir.x * _MOVE_SPEED
		velocity.z = _input_dir.z * _MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, _MOVE_SPEED)
		velocity.z = move_toward(velocity.z, 0, _MOVE_SPEED)
	
	# Turning
	rotate_y(Input.get_axis(right, left) * _TURN_SPEED * delta)
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(grab):
		if not _grabbables.is_empty() and not _grabbed:
			# If the robot should grab something
			# Find the body that is closest to the grab area
			var closest_grabbable: Grabbable
			var min_distance: float = INF
			
			for grabbable in _grabbables:
				if(grabbable.global_position.distance_squared_to(
						_grab_area.global_position
				) < min_distance):
					closest_grabbable = grabbable
			
			# Set the remote transform to the grabbable object
			_grab_transform.remote_path = closest_grabbable.get_path()
			closest_grabbable.grabbed = true
			_grabbed = closest_grabbable
		elif _grabbed:
			# If the robot wants to release what it's grabbing
			_grab_transform.remote_path = ""
			_grabbed.grabbed = false
			_grabbed = null


func _on_grab_area_body_entered(body: Node3D) -> void:
	# Add all nearby Grabbables to the list of possible grabbables
	if body is Grabbable:
		_grabbables.append(body)


func _on_grab_area_body_exited(body: Node3D) -> void:
	# Remove any far Grabbable from the list of possible grabbables
	if body is Grabbable:
		if body in _grabbables:
			var index := _grabbables.find(body)
			_grabbables.remove_at(index)
