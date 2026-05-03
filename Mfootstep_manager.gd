extends Node3D

@export var footstep_sounds1 : Array[AudioStreamMP3]

@export var ground_pos : Marker3D

@onready var monster : CharacterBody3D = get_parent()

@onready var detector = $"../Head/Floor_Detector"

var collider

func _ready() -> void:
	monster.step.connect(play_sound)

func play_sound():
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audio_player.area_mask = 2
	var random_index : int = randi_range(0,footstep_sounds1.size() - 1)
	audio_player.stream = footstep_sounds1[random_index]
	audio_player.pitch_scale = randf_range(0.50,0.60)
	audio_player.volume_db = 0
	
	audio_player.max_distance = 20.0        # how far sound travels
	audio_player.unit_size = 10.0            # scaling of distance falloff
	audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	
	ground_pos.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
