@tool
extends AnimatableBody3D


@export var points: Array[Vector3] = []  
@export var speed: float = 5.0  


var _tween: Tween # we use one tween here to avoid creating multiple tweens and overlapping movements
var _index: int = 0
var _forward: bool = true  # Direction flag


func _ready():	
	if points.size() > 1:
		_move_to_next_point()  


func _move_to_next_point():

	if points.size() < 2:
		return
	
	if _tween:
		_tween.kill()        

	var next_index: int
	if _forward:
		next_index = _index + 1
	else:
		next_index = _index - 1

	if next_index >= points.size():
		_forward = false
		next_index = _index - 1
	elif next_index < 0:
		_forward = true
		next_index = _index + 1
	
	_index = next_index
	
	var next_position = points[next_index]
	var distance = position.distance_to(next_position)
	var move_time = distance / speed

	_tween = create_tween()
	_tween.tween_property(self, "global_position", next_position, move_time)
	_tween.tween_callback(_move_to_next_point).set_delay(0.05)
