@tool
extends Node3D

@onready var dungeon_generator = $"../.."
@onready var navigation_region_3d = $".."
@onready var puzzles = $"../../Puzzles"
@onready var selected_puzzles = $"../../Selected_Puzzles"

@export var grid_map_path : NodePath
@onready var grid_map : GridMap = get_node(grid_map_path)

@export var start : bool = false : set = set_start
func set_start(val:bool)->void:
	for puzzle in puzzles.get_children():
		puzzle.queue_free()
	create_dungeon()
var dun_cell_scene : PackedScene = preload("res://imports/DunCell.tscn")

var directions : Dictionary = {
	"up" : Vector3i.FORWARD,"down" : Vector3i.BACK,
	"left" : Vector3i.LEFT,"right" : Vector3i.RIGHT
}

func handle_none(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
	
func handle_00(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_01(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_02(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_10(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_11(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_12(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_20(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_21(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
func handle_22(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_24(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_25(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_14(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_15(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_41(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_51(cell:Node3D,dir:String):
	cell.call("remove_door_"+dir)
func handle_44(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_55(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_54(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_45(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_42(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_52(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_40(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_04(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_50(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)
func handle_05(cell:Node3D,dir:String):
	cell.call("remove_wall_"+dir)
	cell.call("remove_door_"+dir)

func create_dungeon():
	for c in get_children():
		remove_child(c)
		c.queue_free()
	var t : int = 0
	for cell in grid_map.get_used_cells():
		var cell_index : int = grid_map.get_cell_item(cell)
		if cell_index == 2 or cell_index == 0 or cell_index == 1 or cell_index == 4 or cell_index == 5:
			var dun_cell : Node3D = dun_cell_scene.instantiate()
			dun_cell.position = (Vector3(cell) * 2) + Vector3(1,0,1)
			
			if cell_index == 0 or cell_index == 5:
				var puzzle_box = load("res://Scenes/possible_puzzle_box.tscn").instantiate()
				puzzle_box.global_position = dun_cell.position + Vector3(0.9, 1.5, 0)
				puzzles.add_child(puzzle_box)
				puzzle_box = load("res://Scenes/possible_puzzle_box.tscn").instantiate()
				puzzle_box.global_position = dun_cell.position + Vector3(-0.9, 1.5, 0)
				puzzles.add_child(puzzle_box)
				puzzle_box = load("res://Scenes/possible_puzzle_box.tscn").instantiate()
				puzzle_box.global_position = dun_cell.position + Vector3(0, 1.5, 0.9)
				puzzle_box.rotation = Vector3(0, 1.55, 0)
				puzzles.add_child(puzzle_box)
				puzzle_box = load("res://Scenes/possible_puzzle_box.tscn").instantiate()
				puzzle_box.global_position = dun_cell.position + Vector3(0, 1.5, -0.9)
				puzzle_box.rotation = Vector3(0, -1.55, 0)
				puzzles.add_child(puzzle_box)
				
			
			add_child(dun_cell)
			dun_cell.set_owner(owner)
			t +=1
			for i in 4:
				var cell_n : Vector3i = cell + directions.values()[i]
				var cell_n_index : int = grid_map.get_cell_item(cell_n)
				if cell_n_index ==-1\
				|| cell_n_index == 3:
					handle_none(dun_cell,directions.keys()[i])
				else:
					var key : String = str(cell_index) + str(cell_n_index)
					call("handle_"+key,dun_cell,directions.keys()[i])
		if t%10 == 9 : await get_tree().create_timer(0).timeout
	navigation_region_3d.bake_navigation_mesh(true)
	
	puzzle_selecting()
	
	
	if dungeon_generator.player_pos != null:
		$"../../Player".global_transform.origin = dungeon_generator.player_pos
	if dungeon_generator.player_pos != null:
		$"../../Monster_1".global_transform.origin = dungeon_generator.monster_pos

func puzzle_selecting():
	for child in puzzles.get_children():
		await get_tree().create_timer(0).timeout
		await child.Delete_puzzles()
	
	var PUZZLES = puzzles.get_children()
	var SELECTED_PUZZLES = selected_puzzles.get_children()
	var counter = 0
	
	while counter < dungeon_generator.puzzle_number:
		var PUZZLE = PUZZLES.pick_random()
		if PUZZLE.name.to_int() < dungeon_generator.puzzle_number:
			print("PREVENTED A DUPLICATE OF: ", PUZZLE.name)
		else:
			PUZZLE.name = str(counter)
			puzzles.remove_child(PUZZLE)
			selected_puzzles.add_child(PUZZLE)
			print("Selected puzzle:", PUZZLE.get_index())
			counter += 1
	print("How many selected:", selected_puzzles.get_child_count())
	for i in puzzles.get_children():
		if SELECTED_PUZZLES.has(i):
			print("DUPEEEEEE")
		else:
			puzzles.remove_child(i)
	print("SELECTED:")
	for i in selected_puzzles.get_children():
		print(i)
