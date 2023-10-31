extends Node3D


@export var angle: float
@export var duration: float

var _rotation_tween: Tween


# Godot Messages


func _process(delta):
	if (Input.is_action_just_pressed("rotate_camera_left") or 
		Input.is_action_just_pressed("rotate_camera_right")
	):
		if _rotation_tween != null and _rotation_tween.is_running():
			return
		
		var direction = 0
		if Input.is_action_just_pressed("rotate_camera_left"):
			direction = -1
		
		if Input.is_action_just_pressed("rotate_camera_right"):
			direction = 1
		
		var final = rotation
		final.y += angle * delta * direction
		
		_rotation_tween = create_tween()
		_rotation_tween.set_trans(Tween.TRANS_SINE)
		_rotation_tween.set_ease(Tween.EASE_OUT)
		_rotation_tween.tween_property(self, "rotation", final, duration)
