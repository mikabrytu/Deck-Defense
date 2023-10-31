extends StaticBody3D


@onready var health = $Health


# Godot Messages


func _process(_delta):
	print("Castle Health: %s" % str(health.get_current()))
