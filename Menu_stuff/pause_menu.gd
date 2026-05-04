extends CanvasLayer
@onready var dungeon_generator = $".."


func _on_resume_pressed():
	dungeon_generator.pauseMenu()


func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/main_menu.tscn")
