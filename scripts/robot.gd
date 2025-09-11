class_name Robot
extends CharacterBody3D

signal ungrab_requested ## Emitted when another robot should ungrab something

## Movement speed of the robot
const _MOVE_SPEED := 5
## Turning speed of the robot
const _TURN_SPEED := 5

## Whether the robot can be controlled by the keyboard
@export var keyboard_control := false
@export var forwards: String = "ui_up"
@export var backwards: String = "ui_down"
@export var left: String = "ui_left"
@export var right: String = "ui_right"
@export var grab: String = "ui_accept"

var _forward_axis: float
var _turn_dir: float
## Bodies that can be grabbed by the robot
var _grabbables: Array[Grabbable]
## Body that is currently grabbed by the robot
var _grabbed: Grabbable
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
## Spawn position of the robot
var _spawn := Vector3.ZERO

@onready var _grab_area: Area3D = $GrabArea
@onready var _grab_transform: RemoteTransform3D = $GrabArea/GrabTransform


func _ready() -> void:
	_spawn = global_position + Vector3(0, 0.5, 0)


func _physics_process(delta: float) -> void:
	# Moving forwards and backwards
	var _move_vector := (Vector3(
			_turn_dir,
			0,
			_forward_axis
	)).normalized()
	
	if is_on_floor() and (_forward_axis or _turn_dir):
		velocity.x = _move_vector.x * _MOVE_SPEED
		velocity.z = _move_vector.z * _MOVE_SPEED
		
		look_at(position + velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, _MOVE_SPEED)
		velocity.z = move_toward(velocity.z, 0, _MOVE_SPEED)
	
	# Falling
	velocity.y -= _gravity * delta
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if (
			event.is_action(forwards)
			or event.is_action(backwards)
	) and keyboard_control:
		# If the robot should move forwards or backwards
		_forward_axis = Input.get_axis(forwards, backwards)
	elif (
			event.is_action(right)
			or event.is_action(left)
	) and keyboard_control:
		# If the robot should turn
		_turn_dir = Input.get_axis(left, right)
	elif event.is_action_pressed(grab) and keyboard_control:
		# If the grab button is pressed
		_on_grab_button_pressed()


func respawn() -> void:
	velocity = Vector3.ZERO
	global_position = _spawn


func _on_forward_button_pressed() -> void:
	_forward_axis -= 1


func _on_forward_button_released() -> void:
	_forward_axis += 1


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


func _on_grab_button_pressed() -> void:
	if not _grabbables.is_empty() and not _grabbed:
		# If the robot should grab something
		# Find the grabbable that is closest to the grab area
		var closest_grabbable: Grabbable
		var min_distance: float = INF
		
		for grabbable in _grabbables:
			if(grabbable.global_position.distance_squared_to(
					_grab_area.global_position
			) < min_distance):
				closest_grabbable = grabbable
		
		# Set the remote transform to the closest grabbable
		if closest_grabbable.grabbed:
			ungrab_requested.emit()
			await get_tree().process_frame
		
		closest_grabbable.grabbed = true
		_grab_transform.remote_path = closest_grabbable.get_path()
		_grabbed = closest_grabbable
	elif _grabbed:
		# If the robot wants to release what it's grabbing
		_on_ungrab_requested()


func _on_left_button_pressed() -> void:
	_turn_dir -= 1


func _on_right_button_pressed() -> void:
	_turn_dir += 1


func _on_ungrab_requested() -> void:
	_grab_transform.remote_path = ""
	_grabbed.grabbed = false
	_grabbed = null
