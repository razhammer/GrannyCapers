extends Node


func _ready() -> void:
	SignalHub.on_add_new_scene.connect(on_add_new_scene) 


func add_with_position(ob: Node3D, new_pos: Vector3):
	add_child(ob)
	ob.global_position = new_pos


func on_add_new_scene(ob: Node3D, new_pos: Vector3):
	call_deferred("add_with_position", ob, new_pos)
