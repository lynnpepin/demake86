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
var BeamShot = preload("res://beam_shot.tscn")

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
	
	for ii in 8:
		sprites[ii].visible = false
		sprites[ii].flip_h = [1, 0, 0][flip + 1] # flip = -1 -> 1;  flip = 1 -> 0
		if left:
			sprites[ii].flip_h = 1
		if right:
			sprites[ii].flip_h = 0
	
	
	sprites[angle].visible = true
	
		
	########
	# Handle firing
	########
	shoot(delta)
	
	queue_redraw()

func shoot(delta: float) -> void:
	shoot_timer = max(0, shoot_timer - delta)
	if Input.is_action_pressed("pad_x"):
		if shoot_timer == 0:
			shoot_timer = SHOOT_PERIOD
			var b = BeamShot.instantiate()
			var rawangle = -angle * PI / 4
			b.velocity = Vector2(128.0, 0).rotated(rawangle)
			b.position = global_position + get_shoot_xy(angle)
			b.rotation = rawangle
			if long:
				b.LIFESPAN = 2
			owner.add_child(b)
			
			
			print("Pew")
		draw_circle(Vector2(0,0), 4, Color.GREEN)

func get_shoot_xy(angle):
	return Vector2(
		# Aiming coordinates based on angle
		[4,  4, flip, -4, -4, -3, 0, 3][angle],
		[4, 0, -4, 0,  4, 6, 8, 6][angle]
	)
	
func _draw():
	if Input.is_action_pressed("pad_x"):
		draw_circle(
			get_shoot_xy(angle),
			1.5,
			Color.GREEN,
			false
		)
	
	#if (up or down or left or right or diag):
	#	print(angle)
	
	#  "Per-case" system, for posterity
	#                     lb ↓←↑→
	#if not diag:
		#if not down:
			#if not left:
				#if not up:
					#if not right:
						## _ ____
						#angle = [0, 0, 0, 4, 4, 4, 4, 0][angle] # todo; handle stateful 2 / 6
					#else: #right
						## _ ___→
						#angle = 4
				#else: #up
					#if not right:
						## _ __↑_
						#pass
					#else: 
						## _ __↑→
						#pass
			#else: #left
				#if not up:
					#if not right:
						## _ _←__
						#pass
					#else: #right
						## _ _←_→
						#pass
				#else: #up
					#if not right:
						## _ _←↑_
						#pass
					#else: #right 
						## _ _←↑→
						#pass
		#else: #down
			#if not left:
				#if not up:
					#if not right:
						## _ ↓___
						#pass
					#else: #right
						## _ ↓__→
						#pass
				#else: #up
					#if not right:
						## _ ↓_↑_
						#pass
					#else: 
						## _ ↓_↑→
						#pass
			#else: #left
				#if not up:
					#if not right:
						## _ ↓←__
						#pass
					#else: #right
						## _ ↓←_→
						#pass
				#else: #up
					#if not right:
						## _ ↓←↑_
						#pass
					#else: #right 
						## _ ↓←↑→
						#pass
	#if diag: #diag
		#if not down:
			#if not left:
				#if not up:
					#if not right:
						## _ ____
						#pass
					#else: #right
						## _ ___→
						#pass
				#else: #up
					#if not right:
						## _ __↑_
						#pass
					#else: 
						## _ __↑→
						#pass
			#else: #left
				#if not up:
					#if not right:
						## _ _←__
						#pass
					#else: #right
						## _ _←_→
						#pass
				#else: #up
					#if not right:
						## _ _←↑_
						#pass
					#else: #right 
						## _ _←↑→
						#pass
		#else: #down
			#if not left:
				#if not up:
					#if not right:
						## _ ↓___
						#pass
					#else: #right
						## _ ↓__→
						#pass
				#else: #up
					#if not right:
						## _ ↓_↑_
						#pass
					#else: 
						## _ ↓_↑→
						#pass
			#else: #left
				#if not up:
					#if not right:
						## _ ↓←__
						#pass
					#else: #right
						## _ ↓←_→
						#pass
				#else: #up
					#if not right:
						## _ ↓←↑_
						#pass
					#else: #right 
						## _ ↓←↑→
						#pass
	#
