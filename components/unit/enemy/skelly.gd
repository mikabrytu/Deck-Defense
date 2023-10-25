extends Unit


var _target_health: Health
var _is_attacking: bool = false


# Godot Messages


func _process(delta):
	if _state == UNIT_STATE.ATTACKING:
		_attack()


# Public API


func set_target(target: Node3D):
	_target_health = target.get_node("Health")
	seek_target(target.position)


# Implementation


func _attack():
	if _is_attacking:
		return
	
	if _target != null:
		_is_attacking = true
		start_attacking(_on_attack_timeout)


# Listeners


func _on_attack_timeout():
	EventCenter.damage.emit(_target_health, $Attack.attack_value)
