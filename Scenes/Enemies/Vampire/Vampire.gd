extends CharacterBody3D

@export var speed: float = 5.0


@onready var running_effect: AudioStreamPlayer3D = $RunningEffect
@onready var link_player: LinkPlayer = $LinkPlayer
@onready var falls_off: Node3D = $FallsOff


var _gravity: float = -30.0


func _process(delta: float) -> void:
	var direction: Vector3 = link_player.direction_to_granny(global_position)
	
	

func _on_running_timer_timeout() -> void:
	running_effect.stop()
	running_effect.play() 
