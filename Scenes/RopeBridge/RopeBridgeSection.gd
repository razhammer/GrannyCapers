extends RigidBody3D


@export var impulse: Vector3 = Vector3(0, 10, 0)

@onready var timer: Timer = $Timer



func _on_body_entered(body: Node) -> void:
	if body is Granny and timer.is_stopped():
		apply_central_impulse(impulse)
		timer.start()
