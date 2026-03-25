extends CharacterBody3D


class_name VampireCharacter


@onready var vampire_model: VampireModel = $VampireModel
@onready var running_effect: AudioStreamPlayer3D = $RunningEffect
@onready var link_player: LinkPlayer = $LinkPlayer



var _speed: float = 1.0 
var _gravity: float = -20.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vampire_model.play_walk()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	velocity.y += _gravity * delta
		
	if link_player.granny:
		look_at(link_player.granny_pos_set_y(global_position.y))
		var direction = link_player.direction_to_granny(global_position)		
		
		if !link_player.granny_too_close(global_position):
			velocity.x = direction.x * _speed
			velocity.z = direction.z * _speed
		
	move_and_slide()



func _on_running_timer_timeout() -> void:
	running_effect.stop()
	running_effect.play()

