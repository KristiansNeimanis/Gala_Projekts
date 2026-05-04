extends CharacterBody3D

@onready var player = $"../Player"
@onready var pointer = $pointer
@onready var seeing = false
@onready var in_cone = false
@onready var going = false
@onready var locations = $"../Locations"
@onready var p_collider = null
@onready var seen_timer = $seen_timer
@onready var tracking = false
var tracking_lost_sight = false

@onready var animation = $character/Animation

@onready var agent = $NavigationAgent3D

@onready var character = $character

@onready var attack_area = $Attack_area
var is_attacking = false
var can_attack = true
var is_in_attack_range = false

@onready var body = $CollisionShape3D

@onready var nav = $NavigationAgent3D
var next_location

@onready var SPEED = 1.75
@onready var WALK_SPEED = 1.75
@onready var RUN_SPEED = 3.65

const BOB_FREQ = 2.5
const BOB_AMP = 0.13
var t_bob = 0.0
@onready var camera = $Camera
var can_play : bool = true
signal step

var can_hear = false
var are_alert = false
@onready var allert_time = $allert_time

@onready var random_decision = $Random_decision
var decided = false

@onready var stand_timer = $Stand_timer
var is_standing = false

@onready var groan = $groan
@onready var roar = $roar
var play_roar = true


func _process(_delta):
	if seeing == false and are_alert == false:
		if decided == false:
			decided = true
			random_decision.wait_time = randf_range(10, 15)
			random_decision.start()
	
	if is_in_attack_range == true and seeing == true:
		animation.speed_scale = 1.1
		animation.play("Bite_Action")


func _ready():
	stand_timer.wait_time = 4
	seen_timer.wait_time = 5
	
	animation.play("Walk1_Action")


func _physics_process(delta):
	self.pointer.look_at(player.global_transform.origin)

	if self.pointer.is_colliding():
		p_collider = self.pointer.get_collider()
		if p_collider.is_in_group("Player") == true and in_cone == true:
			seeing = true
			print("SEE YOU!!!!!!!")
			seen_timer.stop()
			
			if !tracking:
				print("TRACKING YOU")
				if play_roar == true:
					roar.play()
					play_roar = false
				tracking = true
				tracking_lost_sight = false
		else:
			if tracking == true and !tracking_lost_sight:
				tracking = false
				seen_timer.start()
				tracking_lost_sight = true

	if !seeing and tracking and seen_timer.is_stopped():
		tracking = false
		tracking_lost_sight = false
		play_roar = true

	if seeing == true:
		going = false
		SPEED = RUN_SPEED
		update_target_location(player.global_transform.origin)
	else:
		if are_alert == true:
			SPEED = RUN_SPEED
		if going == false:
			going = true
			_set_new_destination()

	if seeing == true or are_alert == true:
		if is_in_attack_range == true and seeing == true:
			pass
		elif animation.current_animation != "Walk1_Action":
			animation.speed_scale = 2
			animation.play("Walk1_Action")
	else:
		if animation.current_animation != "Walk1_Action":
			animation.speed_scale = 0.6
			animation.play("Walk1_Action")

	var current_location = self.global_transform.origin
	next_location = nav.get_next_path_position()

	if next_location != Vector3.ZERO:
		var new_velocity = (next_location - current_location).normalized() * SPEED
		character.look_at(next_location)
		nav.set_velocity(new_velocity)

	if is_standing:
		velocity = Vector3.ZERO
		nav.set_velocity(Vector3.ZERO)

		if animation.current_animation != "Idle1_Action":
			animation.play("Idle1_Action")

		move_and_slide()
		return


	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	var low_pos  = BOB_AMP - 0.05
	if pos.y > -low_pos:
		can_play = true
	
	if pos.y < -low_pos and can_play:
		can_play = false
		emit_signal("step")
		
	return pos

func update_target_location(target_location):
	nav.target_position = target_location


func _set_new_destination():
	if are_alert == true:
		SPEED = RUN_SPEED
	else:
		SPEED = WALK_SPEED

	var loc = locations.get_children()
	var location = loc.pick_random()
	
	stand_timer.start()
	groan.play()

	update_target_location(location.global_transform.origin)


func _on_navigation_agent_3d_target_reached():
	if seeing == false:
		self.going = false
		_set_new_destination()


func _on_attack_area_body_entered(body):
	if body.name == player.name:
		is_in_attack_range = true


func _on_attack_area_body_exited(body):
	if body.name == player.name:
		is_in_attack_range = false


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()


func _on_vision_cone_body_entered(body):
	print("IN CONE")
	if body.name == player.name:
		in_cone = true


func _on_vision_cone_body_exited(body):
	print("OUT OF CONE")
	if body.name == player.name:
		in_cone = false


func _on_seen_timer_timeout():
	tracking = false
	tracking_lost_sight = false
	seeing = false


func _on_random_decision_timeout():
	if seeing == true or are_alert == true:
		decided = false
		return

	var roll = randf()

	if roll < 0.30:
		is_standing = true
		stand_timer.start()
		groan.play()

	elif roll < 0.90:
		pass

	else:
		is_standing = true
		stand_timer.start()
		_set_new_destination()
		groan.play()

	decided = false


func _on_stand_timer_timeout():
	is_standing = false
	SPEED = WALK_SPEED


func _on_animation_animation_finished(anim_name):
	if anim_name == "Bite_Action" and is_in_attack_range:
		get_tree().change_scene_to_file("res://Scenes/Menu_stuff/dead.tscn")
