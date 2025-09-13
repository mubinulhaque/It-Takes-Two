extends Node3D

signal pressed(level: String) ## Emitted when the button is pressed

@export_file("*.tscn") var _level: String
@export var _index: = 1

@onready var _audio_player: AudioStreamPlayer3D = $StaticBody3D/AudioStreamPlayer3D
@onready var _label: Label3D = $StaticBody3D/Label3D


func _ready() -> void:
	_label.text = str(_index)


func _on_interactable_area_button_pressed(_button: Variant) -> void:
	pressed.emit(_level)
	_audio_player.play()
