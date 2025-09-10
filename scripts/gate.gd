extends StaticBody3D

## Distance that the gate should be moved upwards once opened
@export var _open_displacement := 5


func _close_gate() -> void:
	global_position.y -= _open_displacement


func _open_gate() -> void:
	global_position.y += _open_displacement
