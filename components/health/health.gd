class_name Health
extends Node3D


@export var max_health: int

var _current: int


# Godot Messages


func _ready():
	reset()


# Public APIs


func reset():
	_current = max_health


func damage(amount: int) -> bool:
	_current -= amount
	return _current < 0


func get_current() -> int:
	return _current


func get_max() -> int:
	return max_health
