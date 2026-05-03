extends Area3D
class_name _Puzzle
@onready var possible_puzzle_box = $"."
@onready var light1 = $light1/OmniLight3D
@onready var light2 = $light2/OmniLight3D
@onready var light3 = $light3/OmniLight3D

@onready var rhandle = $Rhandle
@onready var lhandle = $Lhandle
@onready var mhandle = $Mhandle


@onready var switch = $switch
@onready var beep = $beep
@onready var ding = $ding
var next_beep = 0.75

var hold_time := 0.0
var hold_required := 3
var is_holding := false
var completed := false

var base_r_rot
var base_l_rot
var base_m_pos

func _ready():
	base_r_rot = rhandle.rotation
	base_l_rot = lhandle.rotation
	base_m_pos = mhandle.position
	
func _process(delta):
	if is_holding and not completed:
		hold_time += delta
		
		rhandle.rotation = rhandle.rotation.lerp(base_r_rot + Vector3(0, 0, deg_to_rad(-90)), 0.2)
		lhandle.rotation = lhandle.rotation.lerp(base_l_rot + Vector3(0, 0, deg_to_rad(-90)), 0.2)
		mhandle.position = mhandle.position.lerp(base_m_pos + Vector3(0, -0.2, 0), 0.2)
		
		if hold_time >= next_beep and hold_time < hold_required:
			beep.play()
			if next_beep == 0.75:
				light1.visible = true
			if next_beep == 1.5:
				light2.visible = true
			if next_beep == 2.25:
				light3.visible = true
			next_beep += 0.75
		
		if hold_time >= hold_required:
			complete_puzzle()
	
	else:
		rhandle.rotation = rhandle.rotation.lerp(base_r_rot, 0.2)
		lhandle.rotation = lhandle.rotation.lerp(base_l_rot, 0.2)
		mhandle.position = mhandle.position.lerp(base_m_pos, 0.2)

func start_hold():
	if not is_holding:
		is_holding = true
		hold_time = 0.0
		switch.play()
func stop_hold():
	is_holding = false
	hold_time = 0.0
	next_beep = 0.75
	light1.visible = false
	light2.visible = false
	light3.visible = false
	
func Delete_puzzles():
	await get_tree().create_timer(0).timeout
	if not possible_puzzle_box.has_overlapping_bodies():
		print("DELETING EXCESS")
		self.queue_free()

func complete_puzzle():
	if completed:
		return
	
	completed = true
	is_holding = false
	
	ding.play()


func _on_ding_finished():
	print("PUZZLE COMPLETE")
	$"../../PuzzlesManager".puzzle_completed()
	queue_free()
