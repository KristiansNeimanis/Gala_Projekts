extends Node

var total_puzzles
var puzzles_complete
signal all_puzzles_completed

func _ready():
	puzzles_complete = 0

func puzzle_completed():
	puzzles_complete += 1
	if puzzles_complete == total_puzzles:
		all_puzzles_completed.emit()
