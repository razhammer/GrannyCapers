@tool
extends Collider

class_name HurtBox

signal died
signal damage_taken(amount: int)


@export_category("Hurt Receiver")
@export var kills_parent_on_death: bool = true
@export var dies_on_single_impact: bool = true
@export var max_health: int = 100


var current_health: int:
	get: return current_health
	set(value):
		current_health = value
		if current_health < 0:
			current_health = 0


func _ready() -> void:
	super()
	current_health = max_health



func take_damage(amount: int) -> void:
	if amount <= 0: return
	current_health -= amount
	damage_taken.emit(amount)
	GrannyUtils.print_with_parent(self, "Hurtbox take_damage current_health: %s" % current_health)


	if current_health <= 0:
		die()

func take_hit(amount: int) -> void:
	GrannyUtils.print_with_parent(self, "Hurtbox take_hit!")
	if dies_on_single_impact:
		take_damage(current_health + 1)
		GrannyUtils.print_with_parent(self, "Hurtbox dies_on_single_impact!")
	else:
		take_damage(amount)


func die() -> void:
	died.emit()
	if kills_parent_on_death:
		super()


func _on_area_entered(area: Area3D) -> void:
	if area is DamageCollider:
		GrannyUtils.print_with_parent(self, "Hurtbox _on_area_entered!")
		take_hit(area.get_damage())
