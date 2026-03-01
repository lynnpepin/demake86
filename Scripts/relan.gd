extends CharacterBody2D


@export var HAS_ALL_ITEMS: bool = false

# tiles per second: we want 4, so, speed set to 32
# (speed, jump_speed, high_jump_speed, gravity) = 28, 128, 160, 480
# yields 2 blocks horz or vert for jump, 3 blocks horz or vert for high jump
# speed 30 just lets players make a 2x2 block jump
# speed 32 lets players make a 3 block gap juuuust barely with a generous jump decay
#region constants
var MAX_WALK_SPEED = 32
var MAX_BALL_SPEED = 64
var JUMP_SPEED      = 80 + 48 #+ 32	
var HIGH_JUMP_SPEED = 80 + 80 + 16 #+ 16
var CURRENT_JUMP_SPEED = JUMP_SPEED
var NOMINAL_GRAVITY = 480 #320
var GRAVITY = NOMINAL_GRAVITY #320
var MAX_FALL_SPEED = 128
var START_MISSILES = 0;
var START_ENERGY   = 3;
var MAX_MISSILES = 24
var MAX_ENERGY   = 24
var BOMB_PERIOD: float = 0.5
var BARRIER_RECHARGE_PERIOD: float = 2.86 # todo change
var MAX_BOMBS = 5

var time = 0;
enum States { Normal, Ball, Dead }
#endregion

#region insantiables
var BiggerExplosion = preload("res://Scenes/BiggerExplosion.tscn")
#endregion

#region variables
var state = States.Normal
var is_in_water: bool = false
var vv = Vector2()
var impulse_applied = false # when true, apply impulse for a frame
var ax = MAX_WALK_SPEED * 8
var y_velo = 0.0
var x_velo = 0.0
var grounded = 1.0 # 'grounded' moves from 1.0 to 0.0 on jump and from 1.0 to 0.0 gradually over time in the air
var GROUND_DECAY_RATE = 8  # i.e. set to 12, decay in 1/12th of a second

var energy = 0
var missiles = 0
var hurt_timer = 0
# bombs is a meter which recharges with time
var bombs: float = BOMB_PERIOD * MAX_BOMBS

# power ups
var has_high_jump  = false#false`
var has_morph_ball = false#false
var has_morph_bomb = false#false

var has_long_beam = false
var has_wave_beam = false
var has_ice_beam = false

var has_varia_suit = false
var barrier = false
var barrier_timer = 0

# input
var left: bool
var right: bool

var Bomb = preload("res://Scenes/bomb.tscn")

# children
#var Sounds: Node2D = $Sounds

# Steps counter for step sounds
var steps: float = 0
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
    show_message(" ")
    add_to_group("player")
    set_up_energy_sprites(24)
    set_up_missile_sprites(24)
    # Now, set missiles visible by adding 4
    add_missiles(START_MISSILES)
    add_energy(START_ENERGY)
    $ball_sprite.play()
    if HAS_ALL_ITEMS:
        has_high_jump = true
        has_morph_ball = true
        has_morph_bomb = true
        has_long_beam = true
        has_wave_beam = true
        has_ice_beam = true
        has_varia_suit = true
        
    pass # Replace with function body.

func _physics_process(delta: float) -> void:
    # Set max speed, jump speed
    
    var SPEED
    if state == States.Normal:
        SPEED = MAX_WALK_SPEED
    elif state == States.Ball:
        SPEED = MAX_BALL_SPEED
    else:
        SPEED = MAX_WALK_SPEED
    
    
    if has_high_jump:
        CURRENT_JUMP_SPEED = HIGH_JUMP_SPEED
    else:
        CURRENT_JUMP_SPEED = JUMP_SPEED
        
    check_water()
    if is_in_water:
        SPEED = SPEED / 2
        GRAVITY = NOMINAL_GRAVITY * 2
    else:
        GRAVITY = NOMINAL_GRAVITY
        #CURRENT_JUMP_SPEED = JUMP_SPEED * .75
    
    # Get left/right direction
    left  = Input.is_action_pressed("pad_left")
    right = Input.is_action_pressed("pad_right")
    
    if (left or right) and not (state == States.Dead):
        vv.x = clamp(#        (1 - (1 - grounded)*.5) reduces air movement to 1/2; careful for momentum!
            vv.x + ax*delta * (1 - (1 - grounded)*.5) * (int(right) - int(left)),
            -SPEED, SPEED)
    else:
        # Friction moves toward zero; .75 as fast if player gives no input
        if vv.x < 0:
            vv.x = min(vv.x + ax*delta*.75, 0)
        else:
            vv.x = max(vv.x - ax*delta*.75, 0)
    
    # Play running sprite
    if grounded < .5 or abs(vv.x) > 1:
        $body_sprite.play("run")
        $body_sprite.speed_scale = abs(vv.x) / SPEED
        $ball_sprite.speed_scale = abs(vv.x) / SPEED * .666
    else:
        $body_sprite.play("default")
    
    if is_on_floor():
        if vv.y > 32:
            play_landing_sound() # If landing, play sound
        # Get grounded
        grounded = 1.0
        if not impulse_applied:
            # If on floor, and we're not applying an impulse, zero our velocity
            vv.y = 0
        
        # Walking sounds
        steps += abs(vv.x) * delta #int(round(abs(vv.x) * delta))
        if (steps > SPEED/2) and (left or right):
            steps = 0
            if (state == States.Normal):
                play_landing_sound()
    else:
        grounded = max(0, grounded - delta * GROUND_DECAY_RATE)
        
    # Check again
    if not is_on_floor():
        vv.y = vv.y + GRAVITY * delta
    
    # Enforce max fall speed
    vv.y = min(vv.y, MAX_FALL_SPEED)
    
    # If grounded and jump, set jump speed
    if Input.is_action_just_released("pad_a"):# or Input.is_action_just_pressed("pad_y") or Input.is_action_just_pressed("pad_b"):
        if vv.y < 0 and not (state == States.Dead):
            $Sounds/Jump.seek(.2)
#			$Sounds/Jump.play(0.25)
            vv.y /= 2
    
    if grounded > 0 and Input.is_action_just_pressed("pad_a") and state == States.Normal:
        print(grounded)
        vv.y = -CURRENT_JUMP_SPEED
        
        grounded = 0.0
        $Sounds/Jump.play(0.0);
    
    set_velocity(vv)
    move_and_slide()
    play_screech_sound()
    impulse_applied = false

func apply_impulse(impulse: Vector2):
    # Bad name-- this function is used for bomb.gd explosion physics
    impulse_applied = true
    grounded = 0
    vv.x += impulse.x
    if impulse.y < 0:
        vv.y = min(impulse.y, vv.y)
    elif impulse.y > 0:
        vv.y = max(impulse.y, vv.y)

func check_water():
    is_in_water = false
    for area in $hurt_box.get_overlapping_areas():
        if area.is_in_group("water"):
            is_in_water = true
            # todo - cheap hack
            hurt(area.hurt_value, 3)
        


func _process(delta):
    # timer
    time += delta
    $TimeTyper.target_text = str(snapped(time, 0.1))
    
    if (state == States.Dead):
        return
    
    hurt_timer = max(0, hurt_timer - delta)
    # Make body red when hurt; 0.25 is minimum, so there's no ambiguous area
    var _hurt_timer_color_intensity =  clamp(hurt_timer, 0.25 * int(hurt_timer > 0), 1.0)
    # Round it to steps
    _hurt_timer_color_intensity = floor(_hurt_timer_color_intensity * 4) / 4.0
    var _hurt_timer_color = Color(
        1.0,
        1 - _hurt_timer_color_intensity,# / 2.0,
        1 - _hurt_timer_color_intensity# / 3.0
    )
    $body_sprite.modulate = _hurt_timer_color
    $ball_sprite.modulate = _hurt_timer_color
    
    if Input.is_action_just_pressed("pad_y") or Input.is_action_just_pressed("pad_b"):
        if (state == States.Normal):
            _transition_normal_to_ball()
        elif (state== States.Ball):
            _transition_ball_to_normal()
            
    if Input.is_action_just_pressed("pad_left"):
        $body_sprite.flip_h = 1
        $ball_sprite.flip_h = 1
        #$Node2D_cannon.flip_h = 1
    if Input.is_action_just_pressed("pad_right"):
        $body_sprite.flip_h = 0
        $ball_sprite.flip_h = 0
        #$Node2D_cannon.flip_h = 0
    for input_key in ["pad_left", "pad_right", "pad_up", "pad_down", "pad_a", "pad_b", "pad_x", "pad_y", "pad_lb", "pad_rb"]:
        if Input.is_action_just_pressed(input_key):
            print(input_key, " pressed")
    
    if has_morph_bomb:
        bombs = clamp(bombs + delta, 0, BOMB_PERIOD * MAX_BOMBS)
        if (
            state == States.Ball
            and (Input.is_action_just_pressed("pad_x") or Input.is_action_just_pressed("pad_y"))
            and floor(bombs) > 0
        ):
            var b = Bomb.instantiate()
            b.position = global_position + Vector2(0, 6)
            owner.add_child(b)
            bombs -= BOMB_PERIOD
    
    # set up barrier
    if has_varia_suit:
        barrier_timer = clamp(barrier_timer + delta, 0, BARRIER_RECHARGE_PERIOD)
        if barrier_timer >= BARRIER_RECHARGE_PERIOD:
            regain_barrier()
        
    queue_redraw()

func _transition_normal_to_ball():
    if has_morph_ball:
        $Sounds/ToBall.play()
        assert(state == States.Normal)
        state = States.Ball
        $collision_platforming.set_deferred("disabled", true)
        $collision_platforming_ball.set_deferred("disabled", false)
        $hurt_box/CollisionShape2D.set_deferred("disabled", true)
        $hurt_box/CollisionShape2D_ball.set_deferred("disabled", false)
        $body_sprite.visible = false
        $ball_sprite.visible = true
        $Cannon.process_mode = Node.PROCESS_MODE_DISABLED
        $Cannon.visible = false
        # Disable normal collisions, hurtbox, sprite
        # Enable ball collisions, hurtbox, sprite
        # sounds, no step sounds
        $ball_trail/CPUParticles2D.emitting = true
        $ball_trail/CPUParticles2D_top.emitting = true
        $ball_trail/CPUParticles2D_bot.emitting = true
        $Sprite2D_barrier_feature.offset.y = 6.0

func _transition_ball_to_normal():
    # First, check that there's no clipping
    var coll = $RayCast2D_TuckChecker.get_collider()
    if coll != null:
        $Sounds/CantUntuck.play()
    else:	
        # Then, do the transition
        $Sounds/FromBall.play()
        assert(state == States.Ball)
        state = States.Normal
        $collision_platforming.disabled = false
        $collision_platforming_ball.disabled = true
        $hurt_box/CollisionShape2D.set_deferred("disabled", false)
        $hurt_box/CollisionShape2D_ball.set_deferred("disabled", true)
        $body_sprite.visible = true
        $ball_sprite.visible = false
        $Cannon.process_mode = Node.PROCESS_MODE_ALWAYS
        $Cannon.visible = true
        $ball_trail/CPUParticles2D.emitting = false
        $ball_trail/CPUParticles2D_top.emitting = false
        $ball_trail/CPUParticles2D_bot.emitting = false
        $Sprite2D_barrier_feature.offset.y = 4.0

func play_landing_sound():
    [$Sounds/Land, $Sounds/Land2, $Sounds/Land3, $Sounds/Land4][randi() % 4].play()

func play_screech_sound():
    # todo - add random noises
    # Play sound if changing direction
    if grounded and (left or right):
        if left and (vv.x > MAX_WALK_SPEED/8):
            $Sounds/ChangeDirection.play() 
        elif right and (vv.x < -MAX_WALK_SPEED/8):
            $Sounds/ChangeDirection.play() 
        else:
            $Sounds/ChangeDirection.stop()
    else:
        $Sounds/ChangeDirection.stop()

func hurt(damage: int, cooldown: float) -> void:
    # todo  whether damage should take off last bit of health
    $body_sprite.modulate = Color.RED
    if hurt_timer <= 0:
        hurt_timer = cooldown
        if barrier_timer >= BARRIER_RECHARGE_PERIOD:
            remove_barrier()
        else:
            barrier_timer = 0
            $Sounds/Hurt1.play()
            add_energy(-damage)
    if energy == 0:
        die()
        #print("OH NOOOO")

func remove_barrier():
    barrier_timer = 0
    barrier = false
    $Sprite2D_barrier_feature.modulate = Color(1, 1, 1, 0)
    $Sounds/ShieldHurt.play()
    $Sounds/ShieldBeep.play(0)

func regain_barrier():
    if !barrier:
        barrier = true
        $Sprite2D_barrier_feature.modulate = Color(1,1,1, .5)
        $Sounds/ShieldRegain.play()
        $Sounds/ShieldBeep.stop()

func _draw():
    #draw_circle(Vector2(0,6),6, Color(0, 1.0, 1.0, 0.2), false, -1, false)
    pass   

func show_message(message):
    $Typer.start(message)
#######
# Handle missiles and energy
######
#region Missile and energy counting
func set_up_energy_sprites(set_to: int) -> void:
    pass
    # deprecated -- see $HUD._ready()
    

func set_up_missile_sprites(set_to: int) -> void:
    pass
    # deprecated -- see $HUD._ready()
    

func add_missiles(count: int) -> void:
    # todo - play sound on add missile, lose?
    if count != 0:
        var _set_to = clamp(missiles + count, 0, MAX_MISSILES)
        var _from = min(_set_to, missiles)
        var _to = max(_set_to, missiles)
        for mi in range(_from, _to):
            $HUD.mcounter_sprites[mi].visible = (count > 0)
        missiles = _set_to

func add_energy(count: int) -> void:
    # todo - play sound on add, lose energy?
    if count != 0:
        var _set_to = clamp(energy + count, 0, MAX_ENERGY)
        var _from = min(_set_to, energy)
        var _to = max(_set_to, energy)
        for ei in range(_from, _to):
            $HUD.ecounter_sprites[ei].visible = (count > 0)
        energy = _set_to
#endregion

#region die
func die():
    state = States.Dead
    var blam = BiggerExplosion.instantiate()
    $sprite_boots.visible = true
    blam.position = Vector2(0,0)#global_position
    add_child(blam)
    $body_sprite.visible = false
    $ball_sprite.visible = false
    $hurt_box/CollisionShape2D.set_deferred("disabled", true)
    $hurt_box/CollisionShape2D_ball.set_deferred("disabled", true)
    #$collision_platforming.set_deferred("disabled", true)
    #$collision_platforming_ball.set_deferred("disabled", true)
    $Cannon.process_mode = Node.PROCESS_MODE_DISABLED
    $Cannon.visible = false
    $smoke_boots.emitting = true
    
    pass
#endregion
