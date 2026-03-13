extends Control

@onready var label_jewels: Label = $PC/HB/HBJewel/LabelJewels
@onready var label_coins: Label = $PC/HB/HBCoin/LabelCoins
@onready var key_image: TextureRect = $PC/KeyImage



func _enter_tree() -> void:
	SignalHub.on_pickup_scores_updated.connect(pickup_score_update)
	SignalHub.on_jewels_collected.connect(on_jewels_collected)


func pickup_score_update(scores: PickupScores) -> void: 
	label_jewels.text = "%d/%d" % [scores.jewels_count, scores.jewels_total]
	label_coins.text = "%d/%d" % [scores.coins_count, scores.coins_total]

func on_jewels_collected():
	key_image.show()
	var tween: Tween = create_tween()
	tween.set_loops(0)
	tween.tween_property(key_image, "modulate", Color(1.0,1.0,1.0,0.0), 0.5)
	tween.tween_property(key_image, "modulate", Color(1.0,1.0,1.0,1.0), 0.5)
	
