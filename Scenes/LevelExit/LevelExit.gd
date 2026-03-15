extends Node3D


@onready var label_holder: Node3D = $LabelHolder
@onready var label_key: Label3D = $LabelHolder/LabelKey
@onready var exit_area: Area3D = $ExitArea
@onready var sfx: AudioStreamPlayer3D = $SFX


var key_collected: bool = false



func _ready() -> void:
	SignalHub.on_key_collected.connect(on_key_collected)
	label_holder.hide()
	animate_label()


func animate_label() -> void:
	var tw: Tween = create_tween()
	tw.set_loops()
	tw.tween_property(label_key, "visible", true, 0.6)
	tw.tween_property(label_key, "visible", false, 0.1)


func on_key_collected() -> void:
	key_collected = true



func _on_exit_area_body_entered(_body: Node3D) -> void:
	if key_collected:
		SignalHub.emit_on_level_completed()
	else: 
		label_holder.show()
		sfx.play()


func _on_exit_area_body_exited(_body: Node3D) -> void:
	label_holder.hide()
