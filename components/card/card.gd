extends Area3D


signal card_played(card)

@export_category("Play")
@export var play_speed: float
@export var play_duration: float
@export var play_showcase: float
@export_category("Hover")
@export var hover_y_position: float
@export var hover_position_duration: float
@export var hover_rotate_duration: float

var _hover_tween: Tween
var _hand_position: Vector3
var _hand_rotation: Vector3
var _is_playing: bool = false

const HOVER_Z_AXIS = 0.5


# Public API


func set_card_data(data: CardResource):
	$Name.text = data.name
	$Cost.text = str(data.cost)
	$Icon.texture = data.image


func set_hand_transform():
	_hand_position = position
	_hand_rotation = rotation


# Implementation


func _show_on_hover():
	position.z += HOVER_Z_AXIS
	
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
	if _hover_tween != null and _hover_tween.is_running():
		_hover_tween.stop()
	
	position = _hand_position
	rotation = _hand_rotation


# Listeners


func _on_mouse_entered():
	if position == _hand_position and rotation == _hand_rotation:
		_show_on_hover()


func _on_mouse_exited():
	if not _is_playing:
		_reset_transform()


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("click_left"):
		_is_playing = true
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			self,
			"position",
			Vector3.UP * play_speed,
			play_duration
		)
		
		await get_tree().create_timer(play_showcase).timeout
		
		card_played.emit(self)
		queue_free()
