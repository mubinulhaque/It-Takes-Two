extends Node3D

signal pressed(level: String) ## Emitted when the button is pressed

@export_file("*.tscn") var _level: String


func _on_interactable_area_button_pressed(_button: Variant) -> void:
	pressed.emit(_level)
