extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# tiles per second: we want 4, so, speed set to 32
var SPEED = 4*8
var LIGHT_DIST = 16
var LIGHT_SPEED = 2
var vv = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	DIRECTION.x = (int(Input.is_action_pressed("pad_right")) - int(Input.is_action_pressed("pad_left")))
#	DIRECTION.y = (int(Input.is_action_pressed("pad_down")) - int(Input.is_action_pressed("pad_up")))
#	move_and_slide(DIRECTION.normalized()*SPEED)
	
func _physics_process(delta):
	vv = Vector2()
	if Input.is_action_pressed("pad_right"):
		vv.x += 1
	if Input.is_action_pressed("pad_left"):
		vv.x += -1
	if Input.is_action_pressed("pad_down"):
		vv.y += 1
	if Input.is_action_pressed("pad_up"):
		vv.y += -1
	
	move_and_slide(vv * SPEED)
#	DIRECTION.x = (int(Input.is_action_pressed("pad_right")) - int(Input.is_action_pressed("pad_left")))
#	DIRECTION.y = (int(Input.is_action_pressed("pad_down")) - int(Input.is_action_pressed("pad_up")))
#	move_and_slide(DIRECTION.normalized()*SPEED)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
