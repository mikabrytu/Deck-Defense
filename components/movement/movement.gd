class_name Movement
extends Node3D


@export var speed: float

var _parent


# Public APIs


func set_parent(parent):
	if parent is CharacterBody3D:
		_parent = parent as CharacterBody3D


func move(direction):
	if _parent == null:
		set_parent(get_parent())
	
	var vel = direction * speed
#	_parent.velocity = _parent.velocity.move_toward(velocity, 0.25)
	_parent.velocity = vel
	_parent.move_and_slide()


func rotate_towards(target, delta):
#	# gets the angle we want to face
#	var angle_to_player = global_position.direction_to(target).angle_to(target)
#
#	# slowly changes the rotation to face the angle
#	rotation = move_toward(rotation, angle_to_player, delta)
	pass


func get_speed() -> float:
	return speed
