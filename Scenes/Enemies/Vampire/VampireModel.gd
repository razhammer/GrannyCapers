extends Node3D

class_name VampireModel

@onready var animation_player: AnimationPlayer = $"character-vampire2/AnimationPlayer"

func play_walk() -> void:
	animation_player.play("walk")
