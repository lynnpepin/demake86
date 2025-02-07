extends CharacterBody2D


# tiles per second: we want 4, so, speed set to 32
# (speed, jump_speed, high_jump_speed, gravity) = 28, 128, 160, 480
# yields 2 blocks horz or vert for jump, 3 blocks horz or vert for high jump
# speed 30 just lets players make a 2x2 block jump
# speed 32 lets players make a 3 block gap juuuust barely with a generous jump decay
var SPEED = 32
var JUMP_SPEED      = 80 + 48 #+ 32
var HIGH_JUMP_SPEED = 80 + 80 #+ 16
var GRAVITY = 480 #320
var vv = Vector2()
var ax = 3
var y_velo = 0.0
var x_velo = 0.0

# power ups
var has_high_jump = false

# 'grounded' moves from 1.0 to 0.0 on jump
# and from 1.0 to 0.0 gradually over time in the air
var grounded = 1.0
var GROUND_DECAY_RATE = 8  # i.e. set to 12, decay in 1/12th of a second

# input
var left: bool
var right: bool

func _physics_process(delta: float) -> void:
	# Get left/right direction
	#vv.x = 0
	left  = Input.is_action_pressed("pad_left")
	right = Input.is_action_pressed("pad_right")
	
	if left or right:
		vv.x = clamp(
			vv.x + ax * (int(right) - int(left)),
			-SPEED,
			SPEED
		)
	else:
		if vv.x < 0:
			vv.x = min(vv.x + ax, 0)
		else:
			vv.x = max(vv.x - ax, 0)
	
	#if int(Input.is_action_pressed("ui_right")):
	#	vv.x += 1 * SPEED
	#if Input.is_action_pressed("ui_left"):
	#	vv.x += -1 * SPEED
	
	# Set grounded or not for jumping
	# replaced old check_floor with built-in is_on_floor
	if is_on_floor():
		grounded = 1.0
		vv.y = 0
	else:
		grounded -= delta * GROUND_DECAY_RATE
	
	# Check again
	if not is_on_floor():
		vv.y = vv.y + GRAVITY * delta
	
	# If grounded and jump, set jump speed
	
	if Input.is_action_just_pressed("pad_a"):
		print(grounded)
		#print($Area2D.get_overlapping_bodies())
		#print($RayCast_left.get_collider())
		#print(vv)
	
	if Input.is_action_just_released("pad_a"):
		if vv.y < 0:
			vv.y /= 2
	
	if grounded > 0 and Input.is_action_just_pressed("pad_a"):
		if has_high_jump:
			vv.y = -HIGH_JUMP_SPEED
		else:
			vv.y = -JUMP_SPEED
	
		grounded = 0.0
	
	set_velocity(vv)
	move_and_slide()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func check_floor():
#	return len($Area2D.get_overlapping_bodies()) > 1
	#return $RayCast_left.is_colliding() or $RayCast_right.is_colliding()

#	DIRECTION.x = (int(Input.is_action_pressed("pad_right")) - int(Input.is_action_pressed("pad_left")))
#	DIRECTION.y = (int(Input.is_action_pressed("pad_down")) - int(Input.is_action_pressed("pad_up")))
#	move_and_slide(DIRECTION.normalized()*SPEED)


func _process(delta):
	if Input.is_action_just_pressed("pad_left"):
		pass
		$AnimatedSprite2D_body.flip_h = 1
		#$Node2D_cannon.flip_h = 1
	if Input.is_action_just_pressed("pad_right"):
		pass
		$AnimatedSprite2D_body.flip_h = 0
		#$Node2D_cannon.flip_h = 0
	for input_key in ["pad_left", "pad_right", "pad_up", "pad_down", "pad_a", "pad_b", "pad_x", "pad_y", "pad_lb", "pad_rb"]:
		if Input.is_action_just_pressed(input_key):
			print(input_key, " pressed")
			print("   Angle: ", $Node2D_cannon.angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("mb1"):
#		get_window().set_size(Vector2(4096,4096))
#	if Input.is_action_just_pressed("mb2"):
#		print("yay")
#		
#		var viewport = $Camera2D.get_viewport()
#		var img = $Camera2D.get_viewport().get_texture().get_data() #.queue_screen_capture()
#		#yield(get_tree(), "idle_frame")
#		#yield(get_tree(), "idle_frame")
#	pass
