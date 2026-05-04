extends Control

@onready var time_label = $time_label
@onready var timer = $Timer
@onready var puzzles = $puzzles

var total_time_in_seconds : int = 0

func _ready():
	timer.start()
func _process(_delta):
	puzzles.text = str(PuzzlesManager.puzzles_complete) + "/" + str(PuzzlesManager.total_puzzles)
func _on_timer_timeout():
	total_time_in_seconds += 1
	var m = int(total_time_in_seconds / 60.0)
	var s = total_time_in_seconds - m * 60
	time_label.text = '%02d:%02d' % [m,s]
