
#@tool
extends EnemyClass

var direction: int = 1

@export var start_hp := 2  # new default
@export var zoomer_speed := 12


@export var sprite: SpriteFrames:
    set(value):
        sprite = value
        if $AnimatedSprite2D:
            $AnimatedSprite2D.sprite_frames = value

var angle = 0; # make sure this is 
var rotate_timer = 0.25; # todo delete

var readytimer = 0.125;

# Our rays
@onready var j_ray = $RayCast2D_just_off
@onready var l_ray = $RayCast2D_left
@onready var g_ray = $RayCast2D_ground
@onready var r_ray = $RayCast2D_right
@onready var f_ray = $RayCast2D_forward

var j_col = false
var l_col = false
var g_col = false
var r_col = false
var f_col = false

func _ready():
    if sprite:
        $AnimatedSprite2D.sprite_frames = sprite
    health = start_hp
    speed = zoomer_speed
    angle = transform.get_rotation()
    $AnimatedSprite2D.frame = randi_range(0, 3)
    super()

func spin_cw():
    rotate(PI/2.0)
    angle = fmod(angle + PI / 2.0, PI * 2.0)

func spin_ccw():
    rotate(-PI/2.0)
    angle = fmod(angle - PI / 2.0, PI * 2.0)


func _debugcolor(color=Color.WHITE):
    pass
    #$AnimatedSprite2D.modulate = color

func _physics_process(delta: float) -> void:
    # need readytimer; things work weird without it
    readytimer = max(0.0, readytimer - delta)
    if (freeze_timer <= 0 and health >= 0 and readytimer <= 0.0):
        g_col = g_ray.is_colliding()
        l_col = l_ray.is_colliding()
        r_col = r_ray.is_colliding()
        f_col = f_ray.is_colliding()
        j_col = j_ray.is_colliding()
        
        match [f_col, j_col, l_col, g_col, r_col]:
            [false, false, false, false, false]:
                # todo! orient and fall
                _debugcolor(Color(.5, .5, .5, .25))
                pass
            [false, false, _, _, _]:
                # normal; just move forward
                _debugcolor()
                pass
            [false, true, false, false, _]:
                # "spin cw and move by G 1px"
                # not sure why this is x and not y;
                # not sure why this is 3 and not 1 or 2
                # todo
                _debugcolor(Color.RED)
                move_local_x(-3) 
                spin_cw()
            [false, true, _, _, _]:
                # normal; just move forward
                _debugcolor()
                pass 
            [true, false, _, _, _]:
                # "spin ccw and move G 4 px"
                # hitting a wall while in the air or not
                # again: why is this x not y? why is this 6 not 1?
                # TODO - Floating Zoomer hits this one first
                _debugcolor(Color(0, 1, 0))
                move_local_x(6)
                spin_ccw()
            [true, true, false, false, false]:
                _debugcolor(Color.RED)
                move_local_x(-3) 
                spin_cw()
            [true, true, _, _, _]:
                _debugcolor(Color(0, 1, 0))
                move_local_x(6)
                spin_ccw()
                # todo; move down along ray by 1 pixel
            _:
                # this should not be possible
                print("This should never happen")
                _debugcolor(Color(1, 0, 1, .75))
                pass
        
        var collision = move_and_collide(delta * Vector2(speed , 0).rotated(angle))

func _old_physics_process(delta: float) -> void:
    rotate_timer = clamp(rotate_timer - delta, 0.0, 1.0)
    var ground_coll = $RayCast2D_ground.get_collider()
    
    if freeze_timer <= 0 and health >= 0:
        if ground_coll == null:# and rotate_timer <= 0:
            var left_coll = $RayCast2D_left.get_collider()
            var right_coll = $RayCast2D_right.get_collider()
            
            # if neither or both, move downward until collision; todo
            if left_coll == null and right_coll != null:
                rotate(-PI / 2.0)
                #print("... Zoomer should rotate CCW!")
                angle = fmod(angle - PI / 2.0, PI * 2.0)
                #print("Zoomer rotated; angle=", angle/PI)
                rotate_timer = 0.5
            elif left_coll != null and right_coll == null:
                rotate(PI / 2.0)
                #print("... Zoomer should rotate CW!")
                angle = fmod(angle + PI / 2.0, PI * 2.0)
                #print("Zoomer rotated; angle=", angle/PI)
                rotate_timer = 0.5
            else:
                # todo; 'fall' downward and dont rotate
                pass
            
        #var collision = move_and_collide(delta * Vector2(-speed , 0))
        var collision = move_and_collide(delta * Vector2(speed , 0).rotated(angle))
        #if collision:
        #	direction *= -1
    
    
        
