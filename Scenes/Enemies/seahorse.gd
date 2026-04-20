extends EnemyClass


func _ready() -> void:
    $AnimatedSprite2D.frame = randi_range(0, 4)
    base_speed_scale = randf_range(-4, 4)
    $AnimatedSprite2D.speed_scale = base_speed_scale
    $AnimatedSprite2D.play()
    #print($AnimatedSprite2D.speed_scale)
    super()
