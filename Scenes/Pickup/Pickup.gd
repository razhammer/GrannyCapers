extends Area3D

class_name Pickup


const GROUP_NAME = "Pickup"


enum PickupType { Jewel, Key, Coin }


const PICKUP_POINTS: Dictionary[PickupType, int] = {
	PickupType.Jewel: 10,
	PickupType.Key: 30,
	PickupType.Coin: 5
}


@onready var effects: AudioStreamPlayer3D = $Effects


@export var pickup_type: PickupType = PickupType.Jewel


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)


func get_score() -> int:
	return PICKUP_POINTS[pickup_type]


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
