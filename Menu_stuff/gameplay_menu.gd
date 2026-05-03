extends Node3D

@onready var border = $border
@onready var min = $min
@onready var max = $max
@onready var room = $room
@onready var hallway = $hallway
@onready var puzzle = $puzzle
@onready var seed = $seed

func _on_start_pressed():
	GameplaySettings.border = border.text.to_int()
	GameplaySettings.min = min.text.to_int()
	GameplaySettings.max = max.text.to_int()
	GameplaySettings.room = room.text.to_int()
	GameplaySettings.hallway = hallway.text.to_float()
	GameplaySettings.puzzle = puzzle.text.to_int()
	GameplaySettings.seed = seed.text
	LoadsManager.load_scene("res://Dungeon_generation/dungeon_generator.tscn")
