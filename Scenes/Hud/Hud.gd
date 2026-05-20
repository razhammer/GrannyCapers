extends Control

@onready var label_jewels: Label = $PC/HB/HBJewel/LabelJewels
@onready var label_coins: Label = $PC/HB/HBCoin/LabelCoins
@onready var key_image: TextureRect = $PC/KeyImage
@onready var label_exit: Label = $PC/LabelExit
@onready var level_complete_rect: ColorRect = $LevelCompleteRect
@onready var music: AudioStreamPlayer = $Music
@onready var continue_label: Label = $LevelCompleteRect/VB/ContinueLabel
@onready var label_heart: Label = $PC/HB/HBoxHeart/LabelHeart
@onready var complete_label: Label = $LevelCompleteRect/VB/CompleteLabel
@onready var in_game_music: AudioStreamPlayer = $InGameMusic


const DARKLING = preload("uid://bxnsd1fqwxay")
const PARADISE_FOUND = preload("uid://mh5qe0y1arse")


var _can_continue: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		GameManager.change_to_main()
	elif event.is_action_pressed("shoot") and _can_continue:
		GameManager.load_next_level()


func _ready() -> void:
	get_tree().paused = false
	level_complete_rect.hide()


func _enter_tree() -> void:
	SignalHub.on_pickup_scores_updated.connect(pickup_score_update)
	SignalHub.on_jewels_collected.connect(on_jewels_collected)
	SignalHub.on_key_collected.connect(on_key_collected)
	SignalHub.on_level_completed.connect(on_level_completed)
	SignalHub.on_player_health_change.connect(on_player_health_change)
	SignalHub.on_player_died.connect(on_player_died)


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
	in_game_music.stop()
	get_tree().paused = true
	if is_dead:
		complete_label.text = "Game over!"
	level_complete_rect.show()
	await get_tree().create_timer(1.0).timeout
	if is_dead:
		GrannyUtils.play_clip_plain(music, DARKLING)
	else:
		_can_continue = true
		continue_label.show()
		GrannyUtils.play_clip_plain(music, PARADISE_FOUND)


func on_key_collected():
	key_image.hide()
	label_exit.show()


func on_level_completed() -> void:
	show_game_over(false)


func on_player_health_change(health: int) -> void:
	label_heart.text = "%03d" % health


func on_player_died() -> void:
	show_game_over(true)
