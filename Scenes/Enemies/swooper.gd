extends EnemyClass

var swooping = false

var returning = false
var target

@export var hspeed = 12
@export var swoop_speed = 96
@export var return_speed = 96
@export var return_accel = 384

@export var swoop_period = 2.0
var swoop_timer = 0.0
var last_dir = 1.0

@export var sprite: SpriteFrames:
    set(value):
        sprite = value
        if $AnimatedSprite2D:
            $AnimatedSprite2D.sprite_frames = value

func _ready():
    if sprite:
        $AnimatedSprite2D.sprite_frames = sprite
    $AnimatedSprite2D.frame = randi_range(0, 3)
    super()

func _process(delta: float) -> void:
    super(delta)
    # if see, move toward and swoop
    # jump back up once she's gone
    # maybe replace rays with a box
    

func _physics_process(delta: float) -> void:
    super(delta)
    # We're not frozen, and we have a target:
    if !frozen:
        if target:
            var offset = global_position - target.global_position
            last_dir = sign(offset.x)
            
            if offset.y > 8 or returning:
                # Player is above 
                #if !returning:
                #    print("RETURNING")
                returning = true
                swooping = false
                #swoop_timer = swoop_period
                
            elif offset.y < 0 or swooping:# and swoop_timer <= 0.0:
                # Swooping
                #if !swooping:
                #    print("SWOOPING")
                swooping = true
                returning = false
                # todo - adjust this
                var modulated_swoop_speed = clamp(
                    swoop_speed * (abs(offset.y)/8),
                    swoop_speed / 2.0,
                    swoop_speed
                )
                velocity = Vector2(
                    -hspeed * last_dir, # todo hspeed
                    modulated_swoop_speed
                )
                var col = move_and_slide()
            else:
                #print("SHOULDNT be possible")
                pass
                #swoop_timer = clamp(swoop_timer - delta, 0.0, swoop_period)
                
        if returning or !target:
            velocity.y = max( velocity.y - delta*return_accel, -return_speed)
            velocity.x = - hspeed * last_dir
            var col = move_and_slide()
            if col:
                if get_last_slide_collision().get_normal().y != 0:
                    #print("BONK")
                    swooping = false
                    returning = false

func die():
    super()


func _on_swooping_area_area_entered(area: Area2D) -> void:
    if area.is_in_group("player"):
        target = area

# TODO logic:
# stay still until nearby
# if entered, start "swooping":
# - hspeed moves toward body, stopping on collision with level
# - swoop down, slowing toward area position
# - when area jumps, move back up until ceiling, ending swoop


func _on_swooping_area_area_exited(area: Area2D) -> void:
    target = null
