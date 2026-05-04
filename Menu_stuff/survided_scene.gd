extends Node3D


func _on_main_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/main_menu.tscn")


func _on_again_pressed():
	LoadsManager.load_scene("res://Dungeon_generation/dungeon_generator.tscn")
