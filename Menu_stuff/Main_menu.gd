extends Node3D

func _ready():
	MusicPlayer.play_music(load("res://sounds/bfcmusic-horror-background-ambience-431823.mp3"))

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/gameplay_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()

func _on_stats_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/stats_screen.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/settings_screen.tscn")
