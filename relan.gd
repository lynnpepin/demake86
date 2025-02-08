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
var MAX_FALL_SPEED = 128
var vv = Vector2()
var ax = SPEED * 4
var y_velo = 0.0
var x_velo = 0.0

# There are no energy or missile pickups, aside from etanks and missile tanks
# But the base energy and missiles recharge
var energy = 0
var missiles = 0
var MAX_MISSILES = 24
var MAX_ENERGY   = 24
#var ecount_sprite = ImageTexture.create_from_image(Image.load_from_file("res://art/counters/energy.png"))
#var mcount_sprite = ImageTexture.create_from_image(Image.load_from_file("res://art/counters/missile.png"))
var ecount_sprite = load("res://art/counters/energy.png")
var mcount_sprite = load("res://art/counters/missile.png")
var ecounter_sprites = []
var mcounter_sprites = []


# power ups
var has_high_jump = false

# 'grounded' moves from 1.0 to 0.0 on jump
# and from 1.0 to 0.0 gradually over time in the air
var grounded = 1.0
var GROUND_DECAY_RATE = 8  # i.e. set to 12, decay in 1/12th of a second

# input
var left: bool
var right: bool

# children
#var Sounds: Node2D = $Sounds
var random = RandomNumberGenerator.new()

# Steps counter
var steps: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")
	set_up_energy_sprites(6)
	set_up_missile_sprites(24)
	pass # Replace with function body.

func set_up_energy_sprites(set_to: int) -> void:
	for i in MAX_ENERGY:
		var eicon = Sprite2D.new()
		eicon.texture = ecount_sprite
		eicon.z_index = 1000 - i
		var dx = (i % 6)
		var dy = floor(i / 6)
		eicon.position = Vector2(
			-32 + 2.5 + dx * 3,
			-32 + 2.5 + dy * 2
		)
		eicon.visible = false
		add_child(eicon)
		ecounter_sprites.append(eicon)
	
	add_energy(set_to)

func set_up_missile_sprites(set_to: int) -> void:
	for i in MAX_MISSILES:
		var micon = Sprite2D.new()
		micon.texture = mcount_sprite
		micon.z_index = 1000 - i
		var dx = (i % 4)
		var dy = floor(i / 4)
		micon.position = Vector2(
			29.5 - dx * 2 - int((dy % 2) == 1),
			-32  + 3 + dy*2
		)
		micon.visible = false
		add_child(micon)
		mcounter_sprites.append(micon)
	
	# Now, set missiles visible by adding 4
	add_missiles(set_to)

func add_missiles(count: int) -> void:
	# todo - play sound on add missile, lose?
	if count != 0:
		var _set_to = clamp(missiles + count, 0, MAX_MISSILES)
		var _from = min(_set_to, missiles)
		var _to = max(_set_to, missiles)
		for mi in range(_from, _to):
			mcounter_sprites[mi].visible = (count > 0)
		missiles = _set_to


func add_energy(count: int) -> void:
	# todo - play sound on add, lose energy?
	if count != 0:
		var _set_to = clamp(energy + count, 0, MAX_ENERGY)
		var _from = min(_set_to, energy)
		var _to = max(_set_to, energy)
		for ei in range(_from, _to):
			ecounter_sprites[ei].visible = (count > 0)
		energy = _set_to

func _physics_process(delta: float) -> void:
	# Get left/right direction
	#vv.x = 0
	left  = Input.is_action_pressed("pad_left")
	right = Input.is_action_pressed("pad_right")
	
	if left or right:
		vv.x = clamp(
			#           (1 - (1 - grounded)*.75) reduces air movement to 1/4; momentum is preserved! 
			vv.x + ax*delta * (1 - (1 - grounded)*.5) * (int(right) - int(left)),
			-SPEED,
			SPEED
		)
	else:
		# Friction moves toward zero
		# Only 3/4 as fast as if the player actively presses that way
		if vv.x < 0:
			vv.x = min(vv.x + ax*delta*.75, 0)
		else:
			vv.x = max(vv.x - ax*delta*.75, 0)
	
	# Play running sprite
	if grounded < .5 or abs(vv.x) > 1:
		$body_sprite.play("run")
		$body_sprite.speed_scale = abs(vv.x) / SPEED
	else:
		$body_sprite.play("default")

	
	if is_on_floor():
		# If landing, play sound
		if vv.y > 32:
			play_landing_sound()
		# Get grounded
		grounded = 1.0
		vv.y = 0
		
		# Steps sound
		steps += int(round(abs(vv.x) * delta))
		if (steps > 24) and (left or right):
			steps = 0
			play_landing_sound()
		
	else:
		grounded = max(0, grounded - delta * GROUND_DECAY_RATE)
		
	# Check again
	if not is_on_floor():
		vv.y = vv.y + GRAVITY * delta
	
	# Enforce max fall speed
	vv.y = min(vv.y, MAX_FALL_SPEED)
	
	# If grounded and jump, set jump speed
	if Input.is_action_just_released("pad_a"):
		if vv.y < 0:
			$Sounds/Jump.seek(.2)
#			$Sounds/Jump.play(0.25)
			vv.y /= 2
	
	if grounded > 0 and Input.is_action_just_pressed("pad_a"):
		print(grounded)
		if has_high_jump:
			vv.y = -HIGH_JUMP_SPEED
		else:
			vv.y = -JUMP_SPEED
		
		grounded = 0.0
		$Sounds/Jump.play(0.0);
	
	set_velocity(vv)
	move_and_slide()
	play_screech_sound()
	

func _process(delta):
	if Input.is_action_just_pressed("pad_left"):
		pass
		$body_sprite.flip_h = 1
		#$Node2D_cannon.flip_h = 1
	if Input.is_action_just_pressed("pad_right"):
		pass
		$body_sprite.flip_h = 0
		#$Node2D_cannon.flip_h = 0
	for input_key in ["pad_left", "pad_right", "pad_up", "pad_down", "pad_a", "pad_b", "pad_x", "pad_y", "pad_lb", "pad_rb"]:
		if Input.is_action_just_pressed(input_key):
			print(input_key, " pressed")
			#print("   Angle: ", $Node2D_cannon.angle)
		pass
	
	queue_redraw()

func play_landing_sound():
	[$Sounds/Land, $Sounds/Land2, $Sounds/Land3, $Sounds/Land4][random.randi() % 4].play()

func play_screech_sound():
	# Play sound if changing direction
	if grounded and (left or right):
		if left and (vv.x > SPEED/8):
			$Sounds/ChangeDirection.play() 
		elif right and (vv.x < -SPEED/8):
			$Sounds/ChangeDirection.play() 
		else:
			$Sounds/ChangeDirection.stop()
	else:
		$Sounds/ChangeDirection.stop()

func hurt():
	# todo
	# take arguments: hurt cooldown, damage to take, whether to take last bit of health off
	print("Ouch! That hurt Relan!") # TODO
	
func _draw():
	pass
