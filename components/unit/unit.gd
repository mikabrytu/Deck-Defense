class_name Unit
extends Node3D


enum UNIT_STATE { IDLE, SEEKING, ATTACKING }

@export var distance_to_target: float = 3

var _health: Health
var _movement: Movement
var _anim_converter: PlayerAnimConveter
var _agent: NavigationAgent3D
var _attack_interval: Timer
var _target: Vector3
var _state: UNIT_STATE
var _is_targeted: bool


# Godot Messages


func _physics_process(_delta):
	if _target == null:
		return
	
	look_at(_target, Vector3.UP, true)
	
	if _state == UNIT_STATE.SEEKING:
		var distance = position.distance_to(_target)
		if distance <= distance_to_target:
			change_state(UNIT_STATE.ATTACKING)
			return
	
		var current = global_transform.origin
		var next = _agent.get_next_path_position()
		var direction = (next - current).normalized()
		
		_movement.move(direction)


# Public APIs


func set_unit():
	_health = $Health as Health
	_movement = $Movement as Movement
	_anim_converter = $"Animation Converter" as PlayerAnimConveter
	_agent = $Agent as NavigationAgent3D
	_attack_interval = $"Attack Interval" as Timer
	
	_health.dead.connect(_on_dead)
	
	change_state(UNIT_STATE.IDLE)


func seek_target(target: Vector3):
	_target = target
	_agent.set_target_position(_target)
	
	change_state(UNIT_STATE.SEEKING)


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


func find_closest_enemy(group: String, ignore_targeted: bool = true) -> Unit:
	var enemies = get_tree().get_nodes_in_group(group)
	var enemy = null
	var shortest = 100
	
	for e in enemies:
		if not ignore_targeted and e.is_targeted():
			continue
		
		var distance = position.distance_to(e.position)
		
		if shortest > distance:
			shortest = distance
			enemy = e
	
	return enemy


func change_state(state: UNIT_STATE):
	_state = state
	
	if _anim_converter == null:
		return
	
	if state == UNIT_STATE.IDLE:
		_anim_converter.idle()
	
	if state == UNIT_STATE.SEEKING:
		_anim_converter.run()
	
	if state == UNIT_STATE.ATTACKING:
		_anim_converter.attack()


# Listeners


func _on_dead():
	queue_free()
