extends CharacterBody3D

@onready var player = $"../Player"
@onready var pointer = $pointer
@export var seeing = false
@export var in_cone = false
@export var going = false
@onready var locations = $"../Locations"
@export var p_collider = null
@onready var seen_timer = $seen_timer
@export var tracking = false
var tracking_lost_sight = false

@onready var animation = $character/axe_man2/AnimationPlayer

@onready var agent = $NavigationAgent3D

@onready var physical = $character/axe_man2/Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var character = $character
@onready var armature = $character/axe_man2/Armature

@onready var attack_area = $Attack_area
var is_attacking = false
var can_attack = true
var is_in_attack_range = false

@onready var body = $CollisionShape3D

@onready var nav = $NavigationAgent3D
var next_location

@export var SPEED = 2

var can_hear = false
var are_alert = false
@onready var allert_time = $allert_time

@onready var random_decision = $Random_decision
var decided = false

@onready var stand_timer = $Stand_timer
var is_standing = false


func _process(_delta):
	if seeing == false and are_alert == false:
		if decided == false:
			decided = true
			random_decision.wait_time = randf_range(10, 30)
			random_decision.start()
	
	if is_in_attack_range == true and seeing == true:
		animation.speed_scale = 3.5
		var rand = randi_range(0, 1)
		if(rand == 0):
			animation.play("Throw")
		else:
			animation.play("Throw_2")

func _ready():
	stand_timer.wait_time = 2
	seen_timer.wait_time = 5
	
	physical.active = false
	
	animation.play("Walk_Foward")


func _physics_process(_delta):
	self.pointer.look_at(player.global_transform.origin)
	if self.pointer.is_colliding():
		p_collider = self.pointer.get_collider()
		if p_collider.is_in_group("Player") == true and in_cone == true:
			seeing = true
			
			seen_timer.stop()
			if !tracking:  # Only start tracking if we weren't already
				tracking = true
				tracking_lost_sight = false
				print("Started tracking")
		else:
			if tracking == true and !tracking_lost_sight:
				tracking = false
				print("Player no longer visible, starting timer to stop tracking")
				seen_timer.start()  # Start the timer to stop tracking
				tracking_lost_sight = true  # Mark that we started the timer

	if !seeing and tracking and seen_timer.is_stopped():
		tracking = false
		tracking_lost_sight = false  # Reset the flag once tracking stops
		print("Stopped tracking after timer ran out.")

	if seeing == true:
		going = false
		SPEED = 3
		self.update_target_location(player.global_transform.origin)
		
	else:
		if are_alert == true:
			SPEED = 3.5
		if going == false:
			going = true
			_set_new_destination()
	
	if is_standing == false:
		if seeing == true or are_alert == true or going == true:
			if animation.animation_finished:
				animation.speed_scale = 1
				animation.play("Run_Forward")
			else:
				if animation.animation_finished:
					animation.speed_scale = 1
					animation.play("Walk_Foward")
			
			var current_location = self.global_transform.origin
			next_location = nav.get_next_path_position()
			
			if next_location != Vector3.ZERO:
				var new_velocity = (next_location - current_location).normalized() * SPEED
				character.look_at(next_location)
				nav.set_velocity(new_velocity)
			
				
			if seen_timer.is_stopped() and !seeing:
				tracking = false
				
				
		else:
			if seeing == true or are_alert == true:
				is_standing = false
			else:
				self.velocity = Vector3(-0.1,0,-0.1)
				if animation.animation_finished:
					animation.play("Idle")

func update_target_location(target_location):
	nav.target_position = target_location

func _set_new_destination():
	if are_alert == true:
			SPEED = 4.5
	else:
		SPEED = 2
	var loc = locations.get_children()
	var location = loc.pick_random()
	print(location.get_child(1).mesh.text, location.global_transform.origin)
	self.update_target_location(location.global_transform.origin)
	print("going")


func _on_navigation_agent_3d_target_reached():
	if seeing == false:
		self.going = false
		print("target reached")
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
	if body.name == player.name:
		print("in cone")
		in_cone = true
		

func _on_vision_cone_body_exited(body):
	if body.name == player.name:
		print("out of cone")
		in_cone = false

func _on_seen_timer_timeout():
	print("=================")
	print("STOPED TRACKING")
	print("=================")
	tracking = false  # Stop tracking after timer finishes
	tracking_lost_sight = false  # Reset the flag
	seeing = false  # Optionally reset seeing as well


func _on_hear_area_body_entered(body):
	if body.name == player.name:
		can_hear = true


func _on_hear_area_body_exited(body):
	if body.name == player.name:
		can_hear = false

func _on_random_decision_timeout():
	var rand = randi() % 2
	if rand == 0:
		if seeing == false and are_alert == false:
			is_standing = true
			stand_timer.start()
	if rand == 1:
		if seeing == false and are_alert == false:
			is_standing = true
			stand_timer.start()
			
			_set_new_destination()
	decided = false


func _on_stand_timer_timeout():
	is_standing = false
