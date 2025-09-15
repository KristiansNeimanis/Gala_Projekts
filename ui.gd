extends Control

@onready var time_label = $time_label
@onready var timer = $Timer

var total_time_in_seconds : int = 0

func _ready():
	timer.start()

func _on_timer_timeout():
	total_time_in_seconds += 1
	var m = int(total_time_in_seconds / 60.0)
	var s = total_time_in_seconds - m * 60
	time_label.text = '%02d:%02d' % [m,s]
