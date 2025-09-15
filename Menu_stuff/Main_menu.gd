extends Node3D


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Dungeon_generation/dungeon_generator.tscn")


func _on_quit_pressed():
	get_tree().quit()
