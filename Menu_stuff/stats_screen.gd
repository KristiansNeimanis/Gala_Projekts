extends Node3D
@onready var survived = $Survived
@onready var died = $Died
@onready var switches_pulled = $"Switches pulled"

func _ready():
	update_stats()

func _on_main_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/main_menu.tscn")


func _on_clear_stats_pressed():
	Stats.deaths = 0
	Stats.survives = 0
	Stats.switches_pulled = 0
	Stats.save_stats()
	update_stats()

func update_stats():
	died.text = "Died: " + str(Stats.deaths)
	survived.text = "Survived: " + str(Stats.survives)
	switches_pulled.text = "Switches pulled: " + str(Stats.switches_pulled)
