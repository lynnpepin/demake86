extends AnimatedSprite2D

var lifespan = 1.0;
var timer = 0.0;

var BombExplosion = preload("res://Scenes/BombExplosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    position.x = round(position.x)
    position.y = round(position.y)
    $SoundPlace.play()
    play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    timer += delta
    speed_scale = timer
    if timer >= lifespan:
        print("Bomb exploded")
        var blam = BombExplosion.instantiate()
        #blam.position = global_position
        add_child(blam)
        blam.reparent(get_parent())
        queue_free()
