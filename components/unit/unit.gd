class_name Unit
extends Node3D


enum UNIT_STATE { IDLE, SEEKING, ATTACKING }

@export var distance_to_target: float = 3

var _health: Health
var _movement: Movement
var _agent: NavigationAgent3D
var _attack_interval: Timer
var _target: Vector3
var _state: UNIT_STATE
var _is_targeted: bool


# Godot Messages


func _physics_process(_delta):
	if _target == null:
		return
	
	if _state == UNIT_STATE.SEEKING:
		var distance = position.distance_to(_target)
		if distance <= distance_to_target:
			if _state != UNIT_STATE.ATTACKING:
				_state = UNIT_STATE.ATTACKING
			
			return
	
		var current = global_transform.origin
		var next = _agent.get_next_path_position()
		var direction = (next - current).normalized()
		
		look_at(_target, Vector3.UP, true)
		
		_movement.move(direction)


# Public APIs


func set_unit():
	_health = $Health as Health
	_movement = $Movement as Movement
	_agent = $Agent as NavigationAgent3D
	_attack_interval = $"Attack Interval" as Timer
	
	_health.dead.connect(_on_dead)
	
	_state = UNIT_STATE.IDLE


func seek_target(target: Vector3):
	_target = target
	_agent.set_target_position(_target)
	_state = UNIT_STATE.SEEKING


func start_attacking(callable: Callable):
	_attack_interval.start()
	_attack_interval.connect("timeout", callable)


func stop_attacking(callable):
	_attack_interval.stop()
	_attack_interval.disconnect("timeout", callable)


func is_targeted() -> bool: 
	return _is_targeted


func set_targeted(active: bool = true):
	_is_targeted = active


func find_closest_enemy(group: String) -> Unit:
	var enemies = get_tree().get_nodes_in_group(group)
	var enemy = null
	var shortest = 100
	
	for e in enemies:
		var distance = position.distance_to(e.position)
		
		if shortest > distance:
			shortest = distance
			enemy = e
	
	return enemy


# Listeners


func _on_dead():
	queue_free()
