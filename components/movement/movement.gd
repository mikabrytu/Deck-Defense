class_name Movement
extends Node3D


@export var speed: float

var _parent


# Public APIs


func set_parent(parent):
	if parent is CharacterBody3D:
		_parent = parent as CharacterBody3D


func move(direction):
	var velocity = direction * speed
	_parent.velocity = velocity
	_parent.move_and_slide()


func get_speed() -> float:
	return speed
