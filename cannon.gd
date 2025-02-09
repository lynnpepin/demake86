extends Node2D


# Inputs
var up: bool
var left: bool
var down: bool
var right: bool
var diag: bool

# State
## Shooting state
var long: bool = false
var wave: bool = false
var ice:  bool = false
var charge: bool = false

var shoot_timer: float = 0
var SHOOT_PERIOD: float = .375

## Aiming state
var aimvec: Vector2
var angle: int = 0
var prevangle: int = 0
var flip: int = 0

# Sprites
var sprite
var sprites = [
	$Sprite2D_cannon_f, $Sprite2D_cannon_uf, $Sprite2D_cannon_u,
	$Sprite2D_cannon_uf, $Sprite2D_cannon_f, $Sprite2D_cannon_df,
	$Sprite2D_cannon_d, $Sprite2D_cannon_df
]

var random = RandomNumberGenerator.new()
var BeamShot = preload("res://Scenes/beam_shot.tscn")
var MissileShot = preload("res://Scenes/missile_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	########
	# Handle aiming
	########
	if (angle != prevangle) or Input.is_action_just_pressed("pad_rb"):
		[$Sounds/Click, $Sounds/Click2, $Sounds/Click3, $Sounds/Click4][random.randi() % 4].play()
		
	prevangle = angle
	up = Input.is_action_pressed("pad_up")
	left = Input.is_action_pressed("pad_left")
	down = Input.is_action_pressed("pad_down")
	right = Input.is_action_pressed("pad_right")
	diag = Input.is_action_pressed("pad_lb")
	
	#angle = int(round(
	#	(Vector2(int(right) - int(left), int(up) - int(down)).angle() / PI) 
	#))
	if right:
		flip = 1
	if left:
		flip = -1
	
	aimvec = Vector2(
		#1 - 2*flip,
		int(right) - int(left),
		int(up) - int(down)
	)
	
	if aimvec.length() == 0:
		aimvec.x = flip
	
	angle = posmod(
		int(
			(
				aimvec.angle() / PI) * 4
		),
	8)
	#print(flip, angle)
	
	if diag:
		angle = [
			[1, 1, 1, 1, 1, 7, 7, 7][prevangle],
			1,
			[1, 1, 1, 3, 3, 3, 3, 1][prevangle],
			3,
			[5, 3, 3, 3, 3, 5, 5, 5][prevangle],
			5,
			[7, 7, 5, 5, 5, 5, 7, 7 ][prevangle],
			7
		][angle]
	
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
	# Notice: Beam stays attached to play
	var b = BeamShot.instantiate()
	var rawangle = -angle * PI / 4
	b.velocity = Vector2(128.0, 0).rotated(rawangle)
	b.position = get_shoot_xy(angle)#global_position + get_shoot_xy(angle)
	b.rotation = rawangle
	if long:
		b.LIFESPAN = 2
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
