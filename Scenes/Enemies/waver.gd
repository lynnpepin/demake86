extends EnemyClass

@export var vertical_speed = 8
var col: KinematicCollision2D

func _ready():
    velocity = Vector2(speed, vertical_speed)
    #velocity = Vector2(0, 0)
    super()

func _physics_process(delta: float) -> void:
    
    if !frozen:
        col = move_and_collide(velocity * delta)
        
        if col:
            velocity = velocity.bounce(col.get_normal())
