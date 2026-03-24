extends Node3D

const OFFSET_Y: Vector3 = Vector3(0, 1, 0)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_detect: RayCast3D = $PlayerDetect
@onready var link_player: LinkPlayer = $LinkPlayer


func _physics_process(delta: float) -> void:
	if link_player.granny:
		player_detect.look_at(link_player.granny_pos + OFFSET_Y, Vector3.UP)
		
		open_coffin()



func open_coffin():
	if player_detect.is_colliding() and player_detect.get_collider() == link_player.granny:
		animation_player.play("appear")
		set_physics_process(false)
