class_name Unit
extends Node3D


@onready var health = $Health as Health
@onready var movement = $Movement as Movement
@onready var agent = $Agent as NavigationAgent3D

var _target: Node3D


# Godot Messages


func _physics_process(delta):
	var current = global_transform.origin
	var next = agent.get_next_location()
	var direction = (next - current).normalized()
	
	movement.move(direction)


# Public APIs


func seek_target(target):
	_target = target
	agent.set_target_location(_target)
