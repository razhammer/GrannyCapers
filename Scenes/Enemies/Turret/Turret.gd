extends Node3D


const TURRET_BULLET = preload("uid://dle440yrabavi")


@onready var shoot_timer: Timer = $ShootTimer
@onready var link_player: LinkPlayer = $LinkPlayer
@onready var pivot: Node3D = $Pivot
@onready var effect: AudioStreamPlayer3D = $Effect
@onready var shoot_point: Marker3D = $Pivot/ShootPoint



func _process(delta: float) -> void:
	if !shoot_timer.is_stopped() and link_player.granny:
		pivot.look_at(link_player.granny_pos_set_y(pivot.global_position.y))

func shoot() -> void:
	var nb: TurretBullet = TURRET_BULLET.instantiate()
	SignalHub.emit_on_add_new_scene(nb, shoot_point.global_position)
	effect.play()

func _on_player_detection_body_entered(body: Node3D) -> void:
		shoot_timer.start()


func _on_player_detection_body_exited(body: Node3D) -> void:
		shoot_timer.stop()


func _on_shoot_timer_timeout() -> void:
	shoot()
