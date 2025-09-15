extends CharacterBody3D

#movement
var WALK_SPEED = 3.0
var SPRINT_SPEED = 5.0
var SPEED = WALK_SPEED
const SENSITIVITY = 0.0965

@onready var stamina = $Head/Camera3D/TextureProgressBar

var is_running = false
var STAMINA = 100
var max = 100
#head bob
const BOB_FREQ = 1.6
const BOB_AMP = 0.13
var t_bob = 0.0

var can_play : bool = true
signal step

@onready var follow_head_x = $follow_head_x
@onready var follow_head_y = $follow_head_x/follow_head_y
@onready var flashlight_base = $follow_head_x/follow_head_y/Flashlight
@onready var flashlight = $follow_head_x/follow_head_y/Flashlight/SpotLight3D

@onready var head := $Head
@onready var camera := $Head/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var light_on = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotation_degrees.y += SENSITIVITY * (-event.relative.x)
		camera.rotation_degrees.x += SENSITIVITY * (-event.relative.y)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-55), deg_to_rad(45))

func _physics_process(delta):
	make_flaslight_follow(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	stamina.value = STAMINA
	
	if Input.is_action_pressed("move_run") and STAMINA > 0 and Input.get_vector("move_left", "move_right", "move_forward", "move_backwards"):
		is_running = true
		SPEED = SPRINT_SPEED
		STAMINA -= 0.25
		make_flashlight_droop()
		if STAMINA <= 0:
			SPEED = WALK_SPEED
			is_running = false
	

	if Input.is_action_just_released("move_run") or Input.get_vector("move_left", "move_right", "move_forward", "move_backwards") == null:
		SPEED = WALK_SPEED
		is_running = false
	
	if is_running == false:
		make_flashlight_straighten()
		if STAMINA < max:
			STAMINA += 0.15
		
	
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.visible:
			flashlight.visible = false
			light_on = false
		else:
			flashlight.visible = true
			light_on = true
	
	flashlight.spot_angle = clamp(flashlight.spot_angle, 25, 45)
	flashlight.light_energy = clamp(flashlight.light_energy, 1.2, 3.2)
	flashlight.spot_range = clamp(flashlight.spot_range, 25, 45)
		
	if Input.is_action_just_pressed("scroll_down"):
		flashlight.spot_angle += 1.0
		flashlight.light_energy -= 0.1
		flashlight.spot_range -= 0.1
		
		
		
	if Input.is_action_just_pressed("scroll_up"):
		flashlight.spot_angle -= 1.0
		flashlight.light_energy += 0.1
		flashlight.spot_range += 0.1

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

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

func make_flaslight_follow(delta):
	follow_head_x.rotation = lerp(follow_head_x.rotation, head.rotation, delta * 9.5)
	follow_head_y.rotation = lerp(follow_head_y.rotation, camera.rotation, delta * 9.5)


func make_flashlight_droop():
	flashlight_base.rotation = Vector3(-0.2, 0.02, 0)
	
func make_flashlight_straighten():
	flashlight_base.rotation = Vector3(0, 0.02, 0)
