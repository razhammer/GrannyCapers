extends Node3D

const EXIT = preload("uid://dtsmj51s873n8")
const GHOST = preload("uid://dyu1wks7br31t")


@export var chase_distance: float = 10.0
@export var speed: float = 1.0
@export var frozen_limit: float = 3.0
@export var teleport_radius: float = 10.0

@onready var effects: AudioStreamPlayer3D = $Effects
@onready var link_player: LinkPlayer = $LinkPlayer
@onready var label_debug: Label3D = $LabelDebug


var _on_screen: bool = false
var _frozen_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if !link_player.granny:
		return
	
	var distance_to_player: float = global_position.distance_to(link_player.granny_pos)
	var direction: Vector3 = link_player.direction_to_granny(global_position)
	var close_enough: bool = distance_to_player < chase_distance
	var should_chase: bool = !_on_screen or (_on_screen and close_enough)
	
	if !link_player.granny_too_close(global_position):
		look_at(link_player.granny_pos_set_y(global_position.y))
	
	if should_chase:
		_frozen_timer = 0.0
		position.x += direction.x * speed * delta
		position.z += direction.z * speed * delta
	else: 
		_frozen_timer += delta
		if _frozen_timer >= frozen_limit:
			teleport()


func teleport():
	var random_offset = Vector3(randf_range(-teleport_radius, teleport_radius), 0, randf_range(-teleport_radius, teleport_radius))
	global_position += random_offset
	_frozen_timer = 0.0
	GrannyUtils.play_clip(effects, EXIT)



func _on_screen_notifier_screen_entered() -> void:
	_on_screen = true
	GrannyUtils.play_clip(effects, GHOST)


func _on_screen_notifier_screen_exited() -> void:
	_on_screen = false
