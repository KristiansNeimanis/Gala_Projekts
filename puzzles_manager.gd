extends Node

@onready var dungeon = $".."
var total_puzzles
var puzzles_complete

func _ready():
	total_puzzles = dungeon.puzzle_number
	puzzles_complete = 0

func puzzle_completed():
	puzzles_complete += 1
	if puzzles_complete == total_puzzles:
		$"../Exit".enable_exit()
