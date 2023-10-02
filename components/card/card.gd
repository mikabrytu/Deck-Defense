extends Area3D


@export var hover_y_position: float
@export var hover_position_duration: float
@export var hover_rotate_duration: float

var _hover_tween: Tween
var _hand_position: Vector3
var _hand_rotation: Vector3


# Public API


func set_hand_transform():
	_hand_position = position
	_hand_rotation = rotation


# Implementation


func _show_on_hover():
	if _hover_tween:
		_hover_tween.kill()
	
	_hover_tween = create_tween()
	_hover_tween.set_parallel(true)
	_hover_tween.set_trans(Tween.TRANS_SINE)
	_hover_tween.set_ease(Tween.EASE_IN)
	_hover_tween.tween_property(
		self,
		"rotation",
		Vector3.ZERO,
		hover_rotate_duration
	)
	_hover_tween.tween_property(
		self,
		"position",
		position + (Vector3.UP * hover_y_position),
		hover_position_duration
	)


func _reset_transform():
	if _hover_tween.is_running():
		_hover_tween.stop()
	
	position = _hand_position
	rotation = _hand_rotation


# Listeners


func _on_mouse_entered():
	if position == _hand_position and rotation == _hand_rotation:
		_show_on_hover()


func _on_mouse_exited():
	_reset_transform()
