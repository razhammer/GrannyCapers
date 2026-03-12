extends Node

class_name PickupTracker



var pickup_scores: PickupScores = PickupScores.new()

func _ready() -> void:
	for child in get_tree().get_nodes_in_group(Pickup.GROUP_NAME):
		if child is Pickup:
			match child.pickup_type:
				Pickup.PickupType.Jewel:
					pickup_scores.jewels_total += 1
				Pickup.PickupType.Coin:
					pickup_scores.coins_total += 1
	print(pickup_scores)



func _enter_tree() -> void:
	SignalHub.on_pickup_collected.connect(on_pickup_collected)


func on_pickup_collected(pick_up: Pickup):
	match pick_up.pickup_type:
		Pickup.PickupType.Jewel:
			pickup_scores.jewels_count += 1
		Pickup.PickupType.Coin:
			pickup_scores.coins_count += 1
	print(pickup_scores)
