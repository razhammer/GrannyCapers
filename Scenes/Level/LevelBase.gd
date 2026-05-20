extends Node

const FIREBALL = preload("uid://n3ksvmsoowpn")



func _on_timer_timeout() -> void:
	var fb: Fireball = FIREBALL.instantiate()
	fb.setup(10.0, Vector3(1, 0, 1), 3.0)
	add_child(fb)
	fb.position = Vector3(0, 2, 0)
