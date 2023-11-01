class_name PlayerAnimConveter
extends Node


@export var player: AnimationPlayer
@export var melee: bool
@export var melee_clips: Array[String]
@export var ranged: bool
@export var ranged_clips: Array[String]

var _death_clips: Array[String]


# Godot Messages


func _ready():
	_death_clips = [
		"Death_A",
		"Death_B"
	]


# Public API


func idle():
	_play("Idle")


func run():
	_play("Running_A")


func attack():
	if melee:
		_play(melee_clips.pick_random())
	
	if ranged:
		_play(melee_clips.pick_random())


func hit():
	_play("Hit_B")


func die():
	player.animation_finished.connect(_on_animation_finished)
	
	_play(_death_clips.pick_random())


# Implementation


func _play(clip: String):
	player.play(clip)


# Listeners


func _on_animation_finished(anim_name: StringName):
	for clip in _death_clips:
		if anim_name == clip:
			_play(clip + "_Pose")
			break
