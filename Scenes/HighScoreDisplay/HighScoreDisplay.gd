extends HBoxContainer


class_name HighScoreDisplay


@onready var label_score: Label = $LabelScore
@onready var label_time: Label = $LabelTime



var high_score: HighScore = null



func _ready() -> void:
	if high_score:
		label_score.text = "%04d" % high_score.score
		label_time.text = "%s" % high_score.date_scored


func setup(p_high_score: HighScore):
	high_score = p_high_score
