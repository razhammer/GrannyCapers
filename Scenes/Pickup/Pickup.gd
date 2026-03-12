extends Area3D

class_name Pickup


const GROUP_NAME = "Pickup"


enum PickupType { Jewel, Key, Coin }


@onready var effects: AudioStreamPlayer3D = $Effects


@export var pickup_type: PickupType = PickupType.Jewel


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)

func _disable():
	hide()
	set_deferred("monitoring", false)

func kill():
	effects.play()
	await effects.finished
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body is Granny:
		_disable()
		SignalHub.emit_on_pickup_collected(self)
		kill()
