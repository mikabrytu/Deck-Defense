extends Node3D


@export_category("Player Settings")
@export var player_spawn_point: Marker3D
@export_category("Enemy Settings")
@export var enemy_list: Array[PackedScene]
@export var enemy_target: Node3D


# Godot Messages


func _ready():
	EventCenter.unit_spawned.connect(_on_unit_spawned)


# Listeners


func _on_unit_spawned(unit: PackedScene):
	var u = unit.instantiate()
	u.set_unit()
	add_child(u)
	
	# When using global properties, the instance should be placed in the tree first
	u.global_position = player_spawn_point.global_position


func _on_enemy_spawn_timer_timeout():
	var point = $"Enemy Spawn Path/Locations"
	point.progress_ratio = randf()
	
	# TODO: Make enemy spawn difficulty increase over time
	var e = enemy_list[0].instantiate() 
	e.set_unit()
	e.set_target(enemy_target)
	e.position = point.position
	
	add_child(e)
