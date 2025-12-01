extends Node3D


func _on_play_pressed():
	LoadsManager.load_scene("res://Dungeon_generation/dungeon_generator.tscn")


func _on_quit_pressed():
	get_tree().quit()
