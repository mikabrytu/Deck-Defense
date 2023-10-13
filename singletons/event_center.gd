extends Node


signal card_drawn(card: Area3D, data: CardResource)
signal card_played(card: Area3D, data: CardResource)

signal unit_spawned(unit: Unit)
signal unit_damaged(unit: Unit, damage: int)
signal unit_defeated(unit: Unit)
