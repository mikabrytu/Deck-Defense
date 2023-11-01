extends Unit


var _closest_enemy: Node3D
var _is_attacking: bool = false


# Godot Messages


func _process(_delta):
	if _state == UNIT_STATE.IDLE:
		var enemy = find_closest_enemy("enemies", false)
		if enemy != null:
			_closest_enemy = enemy
			enemy.set_targeted()
			
			seek_target(enemy.position)
	
	if _state == UNIT_STATE.SEEKING:
		if _is_enemy_valid():
			seek_target(_closest_enemy.position)
	
	if _state == UNIT_STATE.ATTACKING:
		_attack()


# Public API


func set_unit():
	super.set_unit()
	
	_health.damaged.connect(_on_damaged)


# Implementation


func _attack():
	if _is_attacking:
		return
	
	_is_attacking = true
	start_attacking(_on_attack)


func _is_enemy_valid() -> bool:
	if is_instance_valid(_closest_enemy):
		return true
	else:
		_reset_unit()
		return false


func _reset_unit():
	stop_attacking(_on_attack)
	
	_closest_enemy = null
	_is_attacking = false
	
	change_state(UNIT_STATE.IDLE)


# Listeners


func _on_attack():
	if _is_enemy_valid():
		_anim_converter.attack()
		
		var enemy_health = _closest_enemy.get_node("Health")
		EventCenter.damage.emit(enemy_health, $Attack.attack_value)


func _on_damaged():
	print("Soldier hit. Current health: %s" % str(_health.get_current()))
