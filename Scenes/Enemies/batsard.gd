extends EnemyClass

@onready var ray_see_left = $RayCast2D_see_left
@onready var ray_see_right = $RayCast2D_see_right
@onready var ray_attack_left = $RayCast2D_attack_left
@onready var ray_attack_right = $RayCast2D_attack_right

var col_see_left : Object
var col_see_right : Object
var col_attack_left : Object
var col_attack_right : Object

var opened = false

func _process(delta: float) -> void:
    # todo:
    # open when you see relan, if is first collider
    col_see_left = ray_see_left.get_collider()
    col_see_right = ray_see_right.get_collider()
    col_attack_left = ray_attack_left.get_collider()
    col_attack_right = ray_attack_right.get_collider()
    
    if !opened:
        if col_see_left != null:
            if col_see_left.is_in_group("player"):
                opened = true
                $AnimatedSprite2D.play()
    
        if col_see_right != null:
            if col_see_right.is_in_group("player"):
                opened = true
                $AnimatedSprite2D.play()
    # fly down when she is near
    
    super(delta)
    
    
func _physics_process(delta: float) -> void:
    super(delta)

func die():
    # todo - create explosion on die
    super()
