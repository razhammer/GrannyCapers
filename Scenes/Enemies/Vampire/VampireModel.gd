extends Node3D

class_name VampireModel

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

func play_walk() -> void:
	animation_player_2.play("walk")
