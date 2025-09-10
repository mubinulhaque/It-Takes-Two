extends Area3D

signal activated ## Emitted when the pressure plate is weighed down
signal deactivated ## Emitted when the pressure plate is no longer weighed down

const _DEFAULT_MASK := 0b0000_0000_0000_0000_0000_0000_1000_0000


func _ready() -> void:
	# Set the collision mask correctly on startup
	collision_mask = _DEFAULT_MASK
	
	# Connect the signals on startup
	body_entered.connect(_on_grabbable_entered)
	body_exited.connect(_on_grabbable_exited)


# When a Grabbable is placed on the pressure plate
func _on_grabbable_entered(_body: Node3D):
	activated.emit()


# When a Grabbable is taken off the pressure plate
func _on_grabbable_exited(_body: Node3D):
	deactivated.emit()
