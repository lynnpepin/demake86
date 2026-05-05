extends CharacterBody2D


@export var SPEED: float = 12.0

var left: bool
var right: bool
var up: bool
var down: bool
var _ls_hz: float
var _ls_vz: float

func _ready():
    add_to_group("player")
    
func _physics_process(delta: float) -> void:
    


    var _ls_hz = Input.get_axis("pad_lstick_left", "pad_lstick_right")
    var _ls_vz = Input.get_axis("pad_lstick_up", "pad_lstick_down")
    up = Input.is_action_pressed("pad_up")       or (_ls_vz < -.5)
    left = Input.is_action_pressed("pad_left")   or (_ls_hz < -.5)
    down = Input.is_action_pressed("pad_down")   or (_ls_vz > .5)
    right = Input.is_action_pressed("pad_right") or (_ls_hz > .5)
    
    set_velocity(
        Vector2(
            int(right) - int(left), int(down) - int(up)
        ) * SPEED
    )
     
    move_and_slide() 
    if velocity.x < 0:
        $AnimatedSprite2D.play("left")
    elif velocity.x > 0:
        $AnimatedSprite2D.play("right")
    else:
        $AnimatedSprite2D.play("default")
