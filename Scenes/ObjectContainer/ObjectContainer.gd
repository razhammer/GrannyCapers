extends Node


const EXPLOSION = preload("uid://c5x3f5e7atbgi")
const SCORE_EFFECT = preload("uid://dbc0e8h60xqat")




func _ready() -> void:
	SignalHub.on_add_new_scene.connect(on_add_new_scene)
	SignalHub.on_add_new_explosion.connect(on_add_new_explosion)
	SignalHub.on_pickup_collected.connect(on_pickup_collected)


func add_with_position(ob: Node3D, new_pos: Vector3):
	add_child(ob)
	ob.global_position = new_pos


func on_add_new_scene(ob: Node3D, new_pos: Vector3):
	call_deferred("add_with_position", ob, new_pos)


func on_add_new_explosion(new_pos: Vector3):
	var ns = EXPLOSION.instantiate()
	on_add_new_scene(ns, new_pos)


func on_pickup_collected(pickup: Pickup):
	var ns: ScoredEffect = SCORE_EFFECT.instantiate()
	ns.setup(pickup.get_score())
	on_add_new_scene(ns, pickup.global_position)
