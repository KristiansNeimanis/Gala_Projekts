extends Node

var resolution_scale := 1.0
var window_mode := 0
var fps_limit := 0
var volume := 0.0
var vsync := false


func _ready():
	load_settings()
	apply_all()


func apply_all():
	_apply_resolution()
	_apply_window()
	_apply_fps()
	_apply_audio()
	_apply_vsync()


# Resolution scaling
func _apply_resolution():
	var viewport = Engine.get_main_loop().root.get_viewport()
	if viewport:
		viewport.scaling_3d_scale = resolution_scale


# Window mode
func _apply_window():
	match window_mode:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


# FPS
func _apply_fps():
	if fps_limit <= 0:
		Engine.max_fps = 0
	else:
		Engine.max_fps = fps_limit


# Audio
func _apply_audio():
	AudioServer.set_bus_volume_db(0, volume)


# VSync
func _apply_vsync():
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	)


# Save
func save_settings():
	var cfg = ConfigFile.new()

	cfg.set_value("graphics", "resolution", resolution_scale)
	cfg.set_value("graphics", "window_mode", window_mode)
	cfg.set_value("graphics", "fps", fps_limit)

	cfg.set_value("audio", "volume", volume)
	cfg.set_value("graphics", "vsync", vsync)

	cfg.save("user://settings.cfg")


# Load
func load_settings():
	var cfg = ConfigFile.new()

	if cfg.load("user://settings.cfg") != OK:
		return

	resolution_scale = cfg.get_value("graphics", "resolution", 1.0)
	window_mode = cfg.get_value("graphics", "window_mode", 0)
	fps_limit = cfg.get_value("graphics", "fps", 0)

	volume = cfg.get_value("audio", "volume", 0.0)
	vsync = cfg.get_value("graphics", "vsync", false)
