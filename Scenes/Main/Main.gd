extends Control


var _can_press: bool = false



func _unhandled_input(event: InputEvent) -> void:
	if _can_press and event.is_action_pressed("shoot"):
		GameManager.load_next_level()



func _ready() -> void:
	get_tree().paused = false


func set_can_press() -> void:
	_can_press = true
