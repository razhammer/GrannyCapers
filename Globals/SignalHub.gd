extends Node


signal on_pickup_collected(pick_up: Pickup)
signal on_pickup_scores_updated(scores: PickupScores)
signal on_jewels_collected

func emit_on_pickup_collected(pick_up: Pickup) -> void:
	on_pickup_collected.emit(pick_up)

func emit_on_pickup_scores_updated(scores: PickupScores) -> void:
	on_pickup_scores_updated.emit(scores)


func emit_on_jewels_collected():
	on_jewels_collected.emit()
