extends Area3D
class_name _Puzzle
@onready var possible_puzzle_box = $"."

func Delete_puzzles():
	await get_tree().create_timer(0).timeout
	if not possible_puzzle_box.has_overlapping_bodies():
		print("DELETING EXCESS")
		self.queue_free()
