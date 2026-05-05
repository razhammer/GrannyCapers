extends CharacterBody3D

class_name Vampire


@onready var running_effect: AudioStreamPlayer3D = $RunningEffect
@onready var link_player: LinkPlayer = $LinkPlayer
@onready var vampire_model: VampireModel = $VampireModel
@onready var blood_sucker: AudioStreamPlayer3D = $BloodSucker


var _gravity: float = -20.0
var speed: float = 10.0


func _ready() -> void:
	vampire_model.play_walk()


func _physics_process(delta: float) -> void:
	velocity.y += _gravity * delta
	if link_player.granny:
		look_at(link_player.granny_pos_set_y(global_position.y))
		var direction: Vector3 = link_player.direction_to_granny(global_position)
		
		if !link_player.granny_too_close(global_position):
			velocity.x = direction.x * speed * delta
			velocity.z = direction.z * speed * delta
	
	move_and_slide()



func _on_running_timer_timeout() -> void:
	running_effect.stop()
	running_effect.play() 


func _on_damage_collider_damage_given(amount: int) -> void:
	if !blood_sucker.playing:
		blood_sucker.play()
