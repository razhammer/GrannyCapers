extends Node3D


class_name ScoredEffect


@onready var score_label: Label3D = $ScoreLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _points: int = 0

func _ready() -> void:
	score_label.text= "+%d" % _points
	animation_player.play("score")
	await animation_player.animation_finished
	queue_free()


func setup(points: int):
	_points = points
