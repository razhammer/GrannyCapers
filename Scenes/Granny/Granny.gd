extends CharacterBody3D

class_name Granny

const GROUP_NAME = "Granny"

@export var gravity: float = -70.0
@export var run_speed: float = 4.0
@export var rotation_speed: float = 2.7
@export var jump_velocity: float = 40.0
@export var double_jump_velocity: float = 20.0
@export var air_control_factor: float = 0.7

@onready var debug_label: Label3D = $DebugLabel



var _can_double_jump: bool = false
var _is_moving: bool = false
var _throwing: bool = false

func _ready() -> void:
	pass 


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)


func _physics_process(delta: float) -> void:
	_handle_input(delta)
	move_and_slide()
	_update_debug()


func _handle_input(delta: float) -> void:
	velocity.y += delta * gravity
	
	
	var rotated: bool = _handle_rotation(delta)
	var moved: bool = _handle_movement()
	_is_moving = rotated or moved
	_handle_jump()


func _handle_movement() -> bool:
	var input: float = Input.get_axis("move_backward","move_forward")
	if is_equal_approx(input, 0.0):
		velocity.x = 0.0
		velocity.z = 0.0
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
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			_can_double_jump = true
		elif _can_double_jump == true and velocity.y > 0:
			velocity.y += double_jump_velocity
			_can_double_jump = false


func _handle_shoot() -> void:
	if Input.is_action_just_pressed("shoot") and !_throwing and is_on_floor():
		_throwing = true


func _update_debug() -> void:
	var s: String = "floor:%s\n" % [is_on_floor()]
	s += "vel: %s\n" % GrannyUtils.formatted_vec3(velocity)
	s += "pos: %s\n" % GrannyUtils.formatted_vec3(global_position)
	debug_label.text = s
