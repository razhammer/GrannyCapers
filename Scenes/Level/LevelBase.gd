extends Node

@onready var music: AudioStreamPlayer = $Music
const FIREBALL = preload("uid://n3ksvmsoowpn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		GameManager.change_to_main()



func _enter_tree() -> void:
	SignalHub.on_level_completed.connect(on_level_completed)


func on_level_completed() -> void:
	music.stop()


func _on_timer_timeout() -> void:
	var fb: Fireball = FIREBALL.instantiate()
	fb.setup(10.0, Vector3(1, 0, 1), 3.0)
	add_child(fb)
	fb.position = Vector3(0, 2, 0)
