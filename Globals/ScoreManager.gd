extends Node


const SCORES_PATH = "user://high_scores.tres"


var _current_score: int = 0
var high_scores: HighScores = HighScores.new()

var current_score: int:
	get: return _current_score
	set(value):
		_current_score = value
		if _current_score < 0: _current_score = 0
		SignalHub.emit_score_change(current_score)
		


func  reset_score():
	current_score = 0


func _ready() -> void:
	SignalHub.on_player_died.connect(on_player_died)
	load_high_scores()


func on_player_died() -> void:
	high_scores.add_new_score(current_score)
	save_high_scores()


func load_high_scores():
	if ResourceLoader.exists(SCORES_PATH):
		high_scores = load(SCORES_PATH)


func save_high_scores():
	ResourceSaver.save(high_scores, SCORES_PATH)
