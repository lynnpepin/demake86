extends EnemyClass

var direction: int = 1

#func _ready():
#	super()

func _process(delta: float) -> void:
    $AnimatedSprite2D.modulate = Color(255.0/255.0, 220.0/255.0, 255.0/255.0)

func _physics_process(delta: float) -> void:
    if freeze_timer <= 0:
        var collision = move_and_collide(delta * Vector2(speed * direction, 0))
        if collision:
            direction *= -1
