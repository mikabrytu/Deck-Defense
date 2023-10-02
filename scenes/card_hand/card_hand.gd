extends Node3D


@export var card_spawn_duration: float

const CARD = preload("res://components/card/card.tscn")


# Godot Messages


func _ready():
	add_cards(5)


# Implementation


func add_cards(amount = 1):
	for i in amount:
		var c = CARD.instantiate()
		add_child(c)
		
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
