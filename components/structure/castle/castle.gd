extends StaticBody3D


@onready var health = $Health


# Godot Messages


func _ready():
	EventCenter.damage.connect(_on_damage)


func _process(delta):
	print("Castle Health: %s" % str(health.get_current()))


# Listeners


func _on_damage(h, damage):
	if h == health:
		health.damage(damage)
