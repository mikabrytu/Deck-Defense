extends Node3D


@export_category("Enemy Settings")
@export var enemy_list: Array[PackedScene]
@export var enemy_spawn_points: Array[Marker3D]
@export var enemy_target: Node3D


# Godot Messages


func _ready():
	EventCenter.unit_spawned.connect(_on_unit_spawned)


# Listeners


func _on_unit_spawned(unit: PackedScene):
	var u = unit.instantiate()
	add_child(u)


func _on_enemy_spawn_timer_timeout():
	var point = enemy_spawn_points.pick_random()
	
	# TODO: Make enemy spawn difficulty increase over time
	var e = enemy_list[0].instantiate() 
	e.set_unit()
	e.set_target(enemy_target)
	e.position = point.position
	
	add_child(e)
