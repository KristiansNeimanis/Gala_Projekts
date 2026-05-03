extends Area3D

@onready var collision_shape_3d = $CollisionShape3D
@onready var win_text = $"../Player/UI/win_text"
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func enable_exit():
	collision_shape_3d.disabled = false
	self.visible = true

func interacted_with():
	win_text.visible = true
	audio_stream_player_3d.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/lived.tscn")
