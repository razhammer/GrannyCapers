extends Node3D


@export var bounce_speed: float = 40.0


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_detect_area: Area3D = $PlayerDetectArea
@onready var effect: AudioStreamPlayer3D = $Effect


func _on_player_detect_area_body_entered(body: Node3D) -> void:
	if body is Granny:
		animation_player.play("toggle")
		effect.play()
		SignalHub.emit_on_player_bounce(bounce_speed)
		print("Bounce Speed: ", bounce_speed)
