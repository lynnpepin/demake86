extends Node2D

# Inputs
var up: bool
var left: bool
var down: bool
var right: bool
var diag: bool

# Powerup state
var long: bool = false
var wave: bool = true
var ice:  bool = false
var charge: bool = false

# Beam specs
var speed: float = 128.0
var shoot_timer: float = 0
var SHOOT_PERIOD: float = .5

## Aiming state
var aimvec: Vector2
var angle: int = 0
var prevangle: int = 0
var flip: int = 1

# Sprites
var sprite
var sprites# = [
	#$Sprite2D_cannon_f, $Sprite2D_cannon_uf, $Sprite2D_cannon_u,
	#$Sprite2D_cannon_uf, $Sprite2D_cannon_f, $Sprite2D_cannon_df,
	#$Sprite2D_cannon_d, $Sprite2D_cannon_df
#]

#var BeamShot = preload("res://Scenes/beam_shot.tscn")
var BeamShot = preload("res://Classes/BeamClass.tscn")
var MissileShot = preload("res://Scenes/Beams/Missile2.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	########
	# Handle aiming
	########
	up = Input.is_action_pressed("pad_up")
	left = Input.is_action_pressed("pad_left")
	down = Input.is_action_pressed("pad_down")
	right = Input.is_action_pressed("pad_right")
	diag = Input.is_action_pressed("pad_lb")
		
	handle_angles()
	
	# For some reason, we need to define this here, not above
	sprites = [
		$Sprite2D_cannon_f, 
		$Sprite2D_cannon_uf,
		$Sprite2D_cannon_u,
		$Sprite2D_cannon_uf,
		$Sprite2D_cannon_f,
		$Sprite2D_cannon_df,
		$Sprite2D_cannon_d,
		$Sprite2D_cannon_df
	]
	
	# Set only the ones we use to visible
	for ii in 8:
		sprites[ii].visible = false
		sprites[ii].flip_h = [1, 0, 0][flip + 1] # flip = -1 -> 1;  flip = 1 -> 0
		if left:
			sprites[ii].flip_h = 1
		if right:
			sprites[ii].flip_h = 0
	
	# Set only our preferred sprite visible
	sprites[angle].visible = true
	
	########
	# Handle firing
	########
	shoot_timer = max(0, shoot_timer - delta)
	shoot(delta)
	
	queue_redraw()

func handle_angles():
	# Eight directions encoded as an int
	# 321
	# 4 0
	# 567
	
	# Make a click noise
	if (angle != prevangle) or Input.is_action_just_pressed("pad_rb"):
		[$Sounds/Click, $Sounds/Click2, $Sounds/Click3, $Sounds/Click4][randi() % 4].play()
	
	prevangle = angle
	
	#angle = int(round((Vector2(int(right) - int(left), int(up) - int(down)).angle() / PI)))
	
	if right:
		flip = 1
	if left:
		flip = -1
	
	# Get the vector representing where we're aiming
	aimvec = Vector2(
		int(right) - int(left), #1 - 2*flip,
		int(up) - int(down)
	)
	
	if aimvec.length() == 0:
		aimvec.x = flip
	
	# Set the angle according to our X-Y components
	angle = posmod(int((aimvec.angle() / PI) * 4),8)
	#print(flip, angle)
	
	# If lb is pressed, use this to map (angle, previous_angle) to an angle
	if diag:
		angle = [
			[1, 1, 1, 1, 1, 7, 7, 7][prevangle],  # right
			1, # up right
			[1, 1, 2 -flip, 3, 3, 3, 3, 1][prevangle], #up
			3,
			[5, 3, 3, 3, 3, 5, 5 , 5][prevangle], # left
			5,
			[7, 7, 5, 5, 5, 5, 6 + flip, 7 ][prevangle], # down
			7
		][angle]

func shoot(delta):
	if Input.is_action_pressed("pad_x"):
		if shoot_timer <= 0:
			shoot_timer = SHOOT_PERIOD
			if Input.is_action_pressed("pad_rb"):
				shoot_missile(delta)
			else:
				shoot_beam(delta)
	
func shoot_missile(delta):
	var _count_missiles = get_parent().missiles
	print("Shooting missle ", _count_missiles)
	if _count_missiles > 0:
		get_parent().add_missiles(-1)
		
		var b = MissileShot.instantiate()
		var rawangle = -angle * PI / 4
		b.velocity = Vector2(128.0, 0).rotated(rawangle)
		b.position = global_position + get_shoot_xy(angle)#global_position + get_shoot_xy(angle)
		b.rotation = rawangle
		owner.owner.add_child(b)
	else:
		$Sounds/Click4.play()
		
func shoot_beam(delta: float) -> void:
	# Create first beam
	var b = BeamShot.instantiate()
	var rawangle = -angle * PI / 4
	b.angle = rawangle
	b.velocity = Vector2(speed, 0).rotated(rawangle)
	b.position = get_shoot_xy(angle) + global_position# + get_shoot_xy(angle)
	b.rotation = rawangle
	owner.owner.add_child(b)
	if long:
		b.LIFESPAN = 2
	b.ice = ice
	owner.add_child(b)
	
	if wave:
		
		# Shoot TWO MORE of them
		b = BeamShot.instantiate()
		b.angle = rawangle
		b.velocity = Vector2(speed/2, 0).rotated(rawangle)
		b.position = get_shoot_xy(angle) + global_position# + get_shoot_xy(angle)
		b.rotation = rawangle
		b.amplitude = 2
		b.frequency = 1.0
		b.phase_angle = 0.5
		owner.owner.add_child(b)
		if long:
			b.LIFESPAN = 2
		b.ice = ice
		owner.add_child(b)
		
		b = BeamShot.instantiate()
		b.angle = rawangle
		b.velocity = Vector2(speed/2, 0).rotated(rawangle)
		b.position = get_shoot_xy(angle) + global_position# + get_shoot_xy(angle)
		b.rotation = rawangle
		b.amplitude = 2
		b.frequency = 1.0
		owner.owner.add_child(b)
		if long:
			b.LIFESPAN = 2
		b.ice = ice
		owner.add_child(b)
		

func get_shoot_xy(angle):
	return Vector2(
		# Aiming coordinates based on angle
		[4,  4, flip, -4, -4, -3, 0, 3][angle],
		[4, 0, -4, 0,  4, 6, 8, 6][angle]
	)


func _highlight_cannon(color):
	draw_circle(
		get_shoot_xy(angle),
		1.5,
		color,
		false
	)
	

func _draw():
	if Input.is_action_pressed("pad_rb"):
		_highlight_cannon(Color.from_string('#52af67', Color.WHITE))
