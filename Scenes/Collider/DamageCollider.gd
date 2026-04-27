@tool
extends Collider

class_name DamageCollider

signal damage_given(amount: int)

@export var damage_amount: int = 10
@export var explodes_on_hit: bool = true
@export var dies_on_hit: bool = true

func get_damage() -> int:
	return damage_amount


func apply_impact_effect():
	damage_given.emit(damage_amount)
	if dies_on_hit:
		die()
		GrannyUtils.print_with_parent(self, "DamageCollider dies_on_hit()")
	if explodes_on_hit:
		GrannyUtils.print_with_parent(self, "DamageCollider explodes_on_hit()")

func _on_area_entered(area: Area3D) -> void:
	GrannyUtils.print_with_parent(self, "DamageCollider _on_area_entered()")
	apply_impact_effect()
