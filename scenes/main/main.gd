extends Node3D


func _process(delta):
	$"FPS Counter".text = "FPS: %s" % str(Engine.get_frames_per_second())
