extends Node3D

signal pressed ## Emitted when the button is pressed
signal released ## Emitted when the button is released

@export var _image: Texture2D ## Image to display on top of the button
@export var _scale := 0.2

@onready var _audio_player: AudioStreamPlayer3D = $StaticBody3D/AudioStreamPlayer3D
@onready var _sprite: Sprite3D = $StaticBody3D/Sprite3D


func _ready() -> void:
	if _sprite and _image:
		_sprite.texture = _image
		_sprite.scale = Vector3(_scale, _scale, _scale)
	elif not _sprite:
		push_error("Error: button cannot find Sprite3D node!")
	else:
		push_error("Error: button has no texture defined!")


func _on_interactable_area_button_pressed(_button: Variant) -> void:
	pressed.emit()
	_audio_player.play()


func _on_interactable_area_button_released(_button: Variant) -> void:
	released.emit()
