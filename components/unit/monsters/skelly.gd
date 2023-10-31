extends Unit


var _main_target: Node3D
var _target_health: Health
var _is_attacking: bool = false


# Godot Messages


func _process(_delta):
	if _state == UNIT_STATE.IDLE:
		set_target(_main_target)
	
	if _state == UNIT_STATE.ATTACKING:
		_attack()


# Public API


func set_unit():
	super.set_unit()
	
	_health.damaged.connect(_on_damaged)


func set_target(target: Node3D):
	_main_target = target
	_target_health = target.get_node("Health")
	
	seek_target(target.position)


# Implementation


func _attack():
	if _is_attacking:
		return
	
	if _target != null and _target_health != null:
		_is_attacking = true
		start_attacking(_on_attack_timeout)
	else:
		_state = UNIT_STATE.IDLE


# Listeners


func _on_attack_timeout():
	EventCenter.damage.emit(_target_health, $Attack.attack_value)


func _on_damaged():
	_state = UNIT_STATE.IDLE
	
	var enemy = find_closest_enemy("player_units")
	if enemy != null:
		seek_target(enemy.position)
