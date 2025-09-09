extends Node3D

signal pressed ## Emitted when the button is pressed
signal released ## Emitted when the button is released


func _on_interactable_area_button_pressed(_button: Variant) -> void:
	pressed.emit()


func _on_interactable_area_button_released(_button: Variant) -> void:
	released.emit()
