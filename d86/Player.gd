extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# tiles per second: we want 4, so, speed set to 32
var SPEED = 4*8
var JUMP_SPEED = 128
var GRAVITY = 400
var vv = Vector2()
var y_velo = 0.0
var x_velo = 0.0

# 'grounded' moves from 1.0 to 0.0 on jump
# and from 1.0 to 0.0 gradually over time in the air
var grounded = 1.0
var GROUND_DECAY_RATE = 12  # i.e. decay in 1/12th of a second

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	DIRECTION.x = (int(Input.is_action_pressed("pad_right")) - int(Input.is_action_pressed("pad_left")))
#	DIRECTION.y = (int(Input.is_action_pressed("pad_down")) - int(Input.is_action_pressed("pad_up")))
#	move_and_slide(DIRECTION.normalized()*SPEED)

func check_floor():
	return len($Area2D.get_overlapping_bodies()) > 1
	#return $RayCast_left.is_colliding() or $RayCast_right.is_colliding()
	
func _physics_process(delta):
	# Get left/right direction
	vv.x = 0
	if Input.is_action_pressed("pad_right"):
		vv.x += 1 * SPEED
	if Input.is_action_pressed("pad_left"):
		vv.x += -1 * SPEED
	
	
	# Set grounded or not for jumping
	if check_floor():
		grounded = 1.0
	else:
		grounded -= delta * GROUND_DECAY_RATE
	
	# If not on floor, gravity
	if not check_floor():
		vv.y = vv.y + GRAVITY * delta
	
	# If grounded and jump, set jump speed
	
	if Input.is_action_just_pressed("pad_a"):
		print(grounded)
		print(check_floor())
		print($Area2D.get_overlapping_bodies())
		#print($RayCast_left.get_collider())
		#print(vv)
		
	if grounded > 0 and Input.is_action_just_pressed("pad_a"):
		vv.y = -JUMP_SPEED
		grounded = 0.0
	
	move_and_slide(vv)
	
#	
#	DIRECTION.x = (int(Input.is_action_pressed("pad_right")) - int(Input.is_action_pressed("pad_left")))
#	DIRECTION.y = (int(Input.is_action_pressed("pad_down")) - int(Input.is_action_pressed("pad_up")))
#	move_and_slide(DIRECTION.normalized()*SPEED)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
