class_name Health
extends Node3D


signal damaged
signal dead

@export var max_health: int

var _current: int


# Godot Messages


func _ready():
	EventCenter.damage.connect(_on_damage)
	
	reset()


# Public APIs


func reset():
	_current = max_health


func damage(amount: int) -> bool:
	_current -= amount
	return _current > 0


func get_current() -> int:
	return _current


func get_max() -> int:
	return max_health


# Listeners


func _on_damage(h, d):
	if h == self:
		var alive = damage(d)
		if not alive:
			dead.emit()
		else:
			damaged.emit()
