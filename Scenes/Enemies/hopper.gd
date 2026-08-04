extends EnemyClass

var PERIOD_TO_NEXT_JUMP = 1.5
var JUMP_VELOCITY = 96
var GRAVITY = 360
var HZ_JUMP_SPEED = 32

var timer: float = 0.0
var grounded: bool = false
var prev_grounded: bool
var vv = Vector2(0,0)

func _ready():
    super()
    timer = randf_range(0, PERIOD_TO_NEXT_JUMP)
    
func _physics_process(delta: float) -> void:
    super(delta)
    if !frozen:
        
        # change sprite on ground change
        grounded = is_on_floor()
        if grounded and (grounded != prev_grounded):
            $AnimatedSprite2D.play("low")
                
                
        # handle physics
        if grounded:
            vv.x = 0
            vv.y = 0
            global_position.x = round(global_position.x)
            timer -= delta
            if timer <= 0.0:
                $AnimatedSprite2D.play("high")
                # jump
                grounded = false
                vv.y = -JUMP_VELOCITY
                vv.x = [-HZ_JUMP_SPEED, HZ_JUMP_SPEED][randi_range(0, 1)]
        else:
            timer = PERIOD_TO_NEXT_JUMP
            vv.y = vv.y + GRAVITY * delta
            pass
        
        set_velocity(vv)
        move_and_slide()
