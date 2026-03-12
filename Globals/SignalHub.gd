extends Node


signal on_pickup_collected(pick_up: Pickup)



func emit_on_pickup_collected(pick_up: Pickup) -> void:
	on_pickup_collected.emit(pick_up)
