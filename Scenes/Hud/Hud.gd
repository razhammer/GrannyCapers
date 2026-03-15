extends Control

@onready var label_jewels: Label = $PC/HB/HBJewel/LabelJewels
@onready var label_coins: Label = $PC/HB/HBCoin/LabelCoins
@onready var key_image: TextureRect = $PC/KeyImage
@onready var label_exit: Label = $PC/LabelExit
@onready var level_complete_rect: ColorRect = $LevelCompleteRect
@onready var music: AudioStreamPlayer = $Music
@onready var continue_label: Label = $LevelCompleteRect/VB/ContinueLabel


const DARKLING = preload("uid://bxnsd1fqwxay")
const PARADISE_FOUND = preload("uid://mh5qe0y1arse")


func _ready() -> void:
	level_complete_rect.hide()


func _enter_tree() -> void:
	SignalHub.on_pickup_scores_updated.connect(pickup_score_update)
	SignalHub.on_jewels_collected.connect(on_jewels_collected)
	SignalHub.on_key_collected.connect(on_key_collected)
	SignalHub.on_level_completed.connect(on_level_completed)


func pickup_score_update(scores: PickupScores) -> void: 
	label_jewels.text = "%d/%d" % [scores.jewels_count, scores.jewels_total]
	label_coins.text = "%d/%d" % [scores.coins_count, scores.coins_total]


func on_jewels_collected():
	key_image.show()
	var tween: Tween = create_tween()
	tween.set_loops(0)
	tween.tween_property(key_image, "modulate", Color(1.0,1.0,1.0,0.0), 0.5)
	tween.tween_property(key_image, "modulate", Color(1.0,1.0,1.0,1.0), 0.5)


func show_game_over(is_dead: bool):
	get_tree().paused = true
	level_complete_rect.show()
	await get_tree().create_timer(1.0).timeout
	continue_label.show()
	GrannyUtils.play_clip_plain(music, PARADISE_FOUND)


func on_key_collected():
	key_image.hide()
	label_exit.show()


func on_level_completed() -> void:
	show_game_over(false)
