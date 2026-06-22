extends CharacterBody3D

class_name Granny

const GROUP_NAME = "Granny"
const FIREBALL = preload("uid://n3ksvmsoowpn")
const JUMPLAND = preload("uid://duunlh38lknrk")
const DOUBLE_JUMP = preload("uid://drdliiaymp00y")
const PLAYER_JUMP = preload("uid://d1lsj8e0bqlvy")


@export var gravity: float = -70.0
@export var run_speed: float = 4.0
@export var rotation_speed: float = 2.7
@export var jump_velocity: float = 40.0
@export var double_jump_velocity: float = 20.0
@export var air_control_factor: float = 0.7
@export var shoot_speed: float = 10.0
@export var vert_shoot_speed: float = 10.0

@onready var debug_label: Label3D = $DebugLabel
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var tree_sm_grounded: AnimationNodeStateMachinePlayback\
			 = animation_tree["parameters/Grounded/playback"]
@onready var shoot_bone: BoneAttachment3D = $Model/Armature/Skeleton3D/ShootBone
@onready var effects: AudioStreamPlayer3D = $Effects
@onready var hurt_sounds: AudioStreamPlayer3D = $HurtSounds
@onready var hurt_box: HurtBox = $HurtBox




var _can_double_jump: bool = false
var _is_moving: bool = false
var _throwing: bool = false
var _was_on_floor: bool = false
var _should_bounce: bool = false
var _bounce_speed: float = 0.0



func _ready() -> void:
	SignalHub.emit_on_player_health_change(hurt_box.current_health)
 


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
	SignalHub.on_player_bounce.connect(on_player_bounce)


func on_player_bounce(bounce_speed: float):
	_should_bounce = true
	_bounce_speed = bounce_speed


func _physics_process(delta: float) -> void:
	_was_on_floor = is_on_floor()
	
	
	if _should_bounce:
		_handle_bounce()
	else: 
		_handle_input(delta)
	move_and_slide()
	_update_debug()
	_check_landing()


func _handle_bounce() -> void:
	velocity = Vector3(0.0, _bounce_speed, 0.0)
	_should_bounce = false


func _check_landing() -> void:
	if _was_on_floor != is_on_floor():
		_was_on_floor = is_on_floor()
		if is_on_floor():
			GrannyUtils.play_clip_stop(effects, JUMPLAND)


func _set_move_zero() -> void:
	velocity.x = 0.0
	velocity.z = 0.0


func _handle_input(delta: float) -> void:
	velocity.y += delta * gravity
	
	if _throwing:
		_is_moving = false
		return
	
	var rotated: bool = _handle_rotation(delta)
	var moved: bool = _handle_movement()
	_is_moving = rotated or moved
	
	_handle_shoot()
	_handle_jump()


func _handle_movement() -> bool:
	var input: float = Input.get_axis("move_backward","move_forward")
	if is_equal_approx(input, 0.0):
		_set_move_zero()
		return false
	
	var direction: Vector3 = transform.basis.z * input
	var speed: float = run_speed if is_on_floor() else run_speed * air_control_factor
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	return true


func _handle_rotation(delta: float) -> bool:
	var input: float = Input.get_axis("move_right","move_left")
	rotate_y(rotation_speed * input * delta)
	return !is_equal_approx(input, 0.0)


func _handle_jump() -> void:
	if _throwing:
		return
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			_can_double_jump = true
			GrannyUtils.play_clip_stop(effects, PLAYER_JUMP)
		elif _can_double_jump == true and velocity.y != null:
			velocity.y += double_jump_velocity
			_can_double_jump = false
			GrannyUtils.play_clip_stop(effects, DOUBLE_JUMP)


func _handle_shoot() -> void:
	if Input.is_action_just_pressed("shoot") and !_throwing and is_on_floor():
		_throwing = true
		_set_move_zero()
		tree_sm_grounded.travel("Throw")


func _update_debug() -> void:
	var s: String = "floor:%s\n" % [is_on_floor()]
	s += "vel: %s\n" % GrannyUtils.formatted_vec3(velocity)
	s += "pos: %s\n" % GrannyUtils.formatted_vec3(global_position)
	debug_label.text = s


func create_fireball() -> void:
	var fb: Fireball = FIREBALL.instantiate()
	fb.setup(shoot_speed, global_transform.basis.z, vert_shoot_speed)
	SignalHub.emit_on_add_new_scene(fb, shoot_bone.global_position)
	

func die():
	SignalHub.emit_on_player_died()
	set_physics_process(false)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Throw":
		_throwing = false
		


func _on_hurt_box_damage_taken(_amount: int) -> void:
	hurt_sounds.play()
	SignalHub.emit_on_player_health_change(hurt_box.current_health)


func _on_hurt_box_died() -> void:
	die()
