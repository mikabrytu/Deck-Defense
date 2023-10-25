extends Node3D


func _process(_delta):
	$"FPS Counter".text = "FPS: %s" % str(Engine.get_frames_per_second())
