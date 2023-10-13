extends Node3D


@export var card_spawn_duration: float
@export_category("Deck")
@export var deck: Array[CardResource]
@export_category("Hand Placement")
@export var position_curve: Curve
@export var height_curve: Curve
@export var height_multiplier: float
@export var rotation_curve: Curve
@export var rotation_multiplier: float
@export_category("Debug")
@export var card_amount: int

var _cards_in_hand: Array[Area3D]
var _position_multiplier: int

const CARD = preload("res://components/card/card.tscn")
const Z_OFFSET = 0.05


# Godot Messages


func _ready():
	$"Debug Hand Position".hide()
	
	_add_cards(card_amount)


# Implementation


func _add_cards(amount = 1):
	for i in amount:
		var c = CARD.instantiate()
		c.connect("card_played_on_contrller", _on_card_played)
		c.position = $"Spawn Point".position
		c.set_card_data(deck.pick_random())
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


func _set_hand(animate: bool = true):
	var total = _cards_in_hand.size()
	var hand_ratio = 0.5
	
	if total > 1:
		for i in total:
			var card = _cards_in_hand[i]
			
			hand_ratio = float(i) / float(total - 1)
			var ratio_values = Vector2(
				position_curve.sample(hand_ratio) * total,
				height_curve.sample(hand_ratio) * height_multiplier
			)
			
			var hand_position = Vector3(
				ratio_values.x,
				ratio_values.y,
				card.position.z + (-Z_OFFSET * i)
			)
			
			var hand_rotation = card.rotation
			hand_rotation.z = rotation_curve.sample(hand_ratio) * rotation_multiplier
			
			if animate:
				var tween = create_tween()
				tween.set_parallel()
				tween.set_trans(Tween.TRANS_BOUNCE)
				tween.set_ease(Tween.EASE_OUT)
				
				tween.tween_property(
					card, 
					"position", 
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
				card.set_hand_transform()
			else:
				card.position = hand_position
				card.rotation = hand_rotation
				card.set_hand_transform()
			
			continue


# Listeners


func _on_card_played(card):
	var index = _cards_in_hand.find(card)
	if index > -1:
		_cards_in_hand.remove_at(index)
		_set_hand(false)
