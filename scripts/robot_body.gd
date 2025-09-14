extends Node3D

@onready var _animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_animator.play("hovering")
