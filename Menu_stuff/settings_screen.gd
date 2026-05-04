extends Node3D

@onready var resolution = $VBoxContainer/HBoxContainer/Resolution
@onready var window_mode = $VBoxContainer/HBoxContainer/Window_mode
@onready var fps_limit = $VBoxContainer/HBoxContainer/FPS
@onready var volume_slider = $VBoxContainer/volume
@onready var vsync_toggle = $VBoxContainer/HBoxContainer/Vsync


func _ready():
	_setup_ui()
	_load_current_values()
	_connect_signals()


# UI setup
func _setup_ui():
	resolution.add_item("100% (Native) Resolution")
	resolution.add_item("75% Resolution")
	resolution.add_item("50% Resolution")
	resolution.add_item("25% Resolution")

	window_mode.add_item("Fullscreen")
	window_mode.add_item("Windowed")
	window_mode.add_item("Borderless Window")
	window_mode.add_item("Borderless Fullscreen")

	fps_limit.add_item("Unlimited FPS")
	fps_limit.add_item("30 FPS")
	fps_limit.add_item("60 FPS")
	fps_limit.add_item("120 FPS")


# Load saved values into UI
func _load_current_values():
	resolution.select(_get_resolution_index(Settings.resolution_scale))
	window_mode.select(Settings.window_mode)
	fps_limit.select(_get_fps_index(Settings.fps_limit))

	volume_slider.value = Settings.volume
	vsync_toggle.button_pressed = Settings.vsync


# Signals
func _connect_signals():
	resolution.item_selected.connect(_on_resolution_item_selected)
	window_mode.item_selected.connect(_on_window_mode_item_selected)
	fps_limit.item_selected.connect(_on_fps_item_selected)
	vsync_toggle.toggled.connect(_on_vsync_toggled)
	volume_slider.value_changed.connect(_on_volume_value_changed)


# Resolution
func _on_resolution_item_selected(index):
	match index:
		0: Settings.resolution_scale = 1.0
		1: Settings.resolution_scale = 0.75
		2: Settings.resolution_scale = 0.5
		3: Settings.resolution_scale = 0.25

	Settings.apply_all()


# Window mode
func _on_window_mode_item_selected(index):
	Settings.window_mode = index
	Settings.apply_all()


# FPS
func _on_fps_item_selected(index):
	match index:
		0: Settings.fps_limit = 0
		1: Settings.fps_limit = 30
		2: Settings.fps_limit = 60
		3: Settings.fps_limit = 120

	Settings.apply_all()


# Volume
func _on_volume_value_changed(value):
	Settings.volume = value
	Settings.apply_all()


# VSync
func _on_vsync_toggled(on):
	Settings.vsync = on
	Settings.apply_all()


# Back button
func _on_main_pressed():
	Settings.save_settings()
	get_tree().change_scene_to_file("res://Scenes/Menu_stuff/main_menu.tscn")


# Helpers
func _get_resolution_index(scale):
	if scale >= 1.0:
		return 0
	elif scale >= 0.75:
		return 1
	elif scale >= 0.5:
		return 2
	else:
		return 3


func _get_fps_index(fps):
	match fps:
		0: return 0
		30: return 1
		60: return 2
		120: return 3
	return 0
