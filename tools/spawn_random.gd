@tool
extends Node


@export_category("Mesh Settings")
@export var amount: int
@export var meshes: Array[Mesh]
@export_category("Positions Settings")
@export var bounds: Vector2
@export var height_offset: Vector2
@export_category("Avoidance")
@export var avoid_list: Array[Node3D]
@export var avoid_distance: float
@export var mesh_distance: float
@export_category("Fine Tunning")
@export var scale: float

var spawned: Array[MeshInstance3D] = []


func _get_tool_buttons(): return [spawn, clear]


func spawn():
	for i in amount:
		var pos = generate_position()
		while not _is_position_valid(pos):
			pos = generate_position()
		
		var instance = MeshInstance3D.new()
		instance.set_mesh(meshes.pick_random())
		instance.rotate_y(randi_range(0, 360))
		instance.position = pos
		instance.scale = Vector3.ONE * scale
		
		add_child(instance, true)
		instance.set_owner(get_tree().get_edited_scene_root())
		
		spawned.append(instance)
	
	print("Spawned %s itens" % spawned.size())


func clear():
	for s in spawned:
		s.queue_free()
	
	spawned.clear()
	
	var message = "Cleared" if spawned.size() == 0 else "There's still itens in the scene"
	print(message)


func generate_position() -> Vector3:
	return Vector3(
		randf_range(bounds.x, bounds.y),
		randf_range(height_offset.x, height_offset.y),
		randf_range(bounds.x, bounds.y)
	)


func _is_position_valid(pos: Vector3) -> bool:
	var distance = 100
	
	for a in avoid_list:
		distance = pos.distance_to(a.position)
		if distance < avoid_distance:
			return false
	
	for s in spawned:
		distance = pos.distance_to(s.position)
		if distance < mesh_distance:
			return false
	
	return true
