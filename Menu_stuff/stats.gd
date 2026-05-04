extends Node

var deaths := 0
var survives := 0
var switches_pulled := 0

const SAVE_PATH := "user://stats.cfg"

func _ready():
	load_stats()

func save_stats():
	var config = ConfigFile.new()

	config.set_value("stats", "deaths", deaths)
	config.set_value("stats", "survives", survives)
	config.set_value("stats", "switches_pulled", switches_pulled)

	config.save(SAVE_PATH)

func load_stats():
	var config = ConfigFile.new()

	if config.load(SAVE_PATH) == OK:
		deaths = config.get_value("stats", "deaths", 0)
		survives = config.get_value("stats", "survives", 0)
		switches_pulled = config.get_value("stats", "switches_pulled", 0)
