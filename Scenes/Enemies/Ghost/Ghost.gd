extends Node3D

const EXIT = preload("uid://dtsmj51s873n8")
const GHOST = preload("uid://dyu1wks7br31t")


@export var chase_distance: float = 10.0
@export var speed: float = 1.0

@onready var effects: AudioStreamPlayer3D = $Effects
@onready var link_player: LinkPlayer = $LinkPlayer


var _on_screen: bool = false


func _process(delta: float) -> void:
	if !link_player.granny:
		return
	
	var distance_to_player: float = global_position.distance_to(link_player.granny_pos)
	var direction: Vector3 = link_player.direction_to_granny(global_position)
	var close_enough: bool = distance_to_player < chase_distance
	var should_chase: bool = !_on_screen or (_on_screen and close_enough)
	
	
	look_at(link_player.granny_pos_set_y(global_position.y))
	
	if should_chase:
		position.x += direction.x * speed * delta
		position.z += direction.z * speed * delta

func _on_screen_notifier_screen_entered() -> void:
	_on_screen = true
	GrannyUtils.play_clip(effects, GHOST)


func _on_screen_notifier_screen_exited() -> void:
	_on_screen = false
