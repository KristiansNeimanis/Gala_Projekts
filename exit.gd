extends Area3D

@onready var collision_shape_3d = $CollisionShape3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D
@onready var lid = $lid

func enable_exit():
	collision_shape_3d.disabled = false
	lid.position = Vector3(-0.15, 0.3, 0)
	lid.rotation = Vector3(0, 0, deg_to_rad(45))

func interacted_with():
	audio_stream_player_3d.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/lived.tscn")
