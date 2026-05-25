@tool
extends PathFollow3D


@export var speed: float = 2.0


var _direction: int = 1


func _physics_process(delta: float) -> void:
	if _direction == 1 and progress_ratio > 0.99:
		_direction = -1
	elif _direction == -1 and progress_ratio < 0.01:
		_direction = 1
	progress += delta * speed * _direction
