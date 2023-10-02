extends Node3D


@export var card_spawn_duration: float
@export_category("Hand Placement")
@export var position_curve: Curve
@export var position_multiplier: float
@export var height_curve: Curve
@export var height_multiplier: float
@export var rotation_curve: Curve
@export var rotation_multiplier: float
@export_category("Debug")
@export var card_amount: int

var _cards_in_hand: Array[Node3D]

const CARD = preload("res://components/card/card.tscn")


# Godot Messages


func _ready():
	$MeshInstance3D.hide()
	
	_add_cards(card_amount)


# Implementation


func _add_cards(amount = 1):
	for i in amount:
		var c = CARD.instantiate()
		add_child(c)
		_cards_in_hand.append(c)
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(
			c, 
			"scale", 
			Vector3.ONE, 
			card_spawn_duration
		).from(Vector3.ZERO)

		await get_tree().create_timer(card_spawn_duration / 2).timeout
		continue
	
	_set_hand()


func _set_hand():
	var total = _cards_in_hand.size()
	var hand_ratio = 0.5
	
	if total > 1:
		for i in total:
			var card = _cards_in_hand[i]
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.set_ease(Tween.EASE_OUT)
			
			hand_ratio = float(i) / float(total - 1)
			var ratio_values = Vector2(
				position_curve.sample(hand_ratio) * position_multiplier,
				height_curve.sample(hand_ratio) * height_multiplier
			)
			
			var hand_position = Vector3(
				card.global_position.x + ratio_values.x,
				card.global_position.y + ratio_values.y,
				card.global_position.z
			)
			
			var hand_rotation = card.rotation
			hand_rotation.z = rotation_curve.sample(hand_ratio) * rotation_multiplier
			
			tween.tween_property(
				card, 
				"global_position", 
				hand_position, 
				card_spawn_duration / 4
			)
			tween.tween_property(
				card,
				"rotation",
				hand_rotation,
				card_spawn_duration / 4
			)
			
			await get_tree().create_timer(card_spawn_duration / 4).timeout
			continue
