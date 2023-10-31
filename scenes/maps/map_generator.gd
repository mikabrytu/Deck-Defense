extends NavigationRegion3D


@export var environment_scenes: Array[PackedScene]
@export var spawn_points_parent: Node3D
@export var environment_parent: Node3D
@export var scene_scale: float


# Godot Messages


func _ready():
	for p in spawn_points_parent.get_children(true):
		p.position.y = 1
		
		var e = environment_scenes.pick_random().instantiate()
		e.position = p.position
		e.rotate_y(randi_range(0, 360))
		e.scale = Vector3.ONE * scene_scale
		
		environment_parent.add_child(e)
