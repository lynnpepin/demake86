extends RigidBody2D

var size: int = 8
var health: float = 24.0

func _ready() -> void:
    size = [8, 12, 16].pick_random()
    health = float(size)
    $CollisionShape2D.shape.size.x = size - 2.0
    $CollisionShape2D.shape.size.y = size - 2.0
    angular_velocity = randf_range(-20.0 + size, 20.0 - size)
    match size:
        8: $Sprites_8px.get_children().pick_random().visible = true
        12: $Sprite2D_12.visible = true
        16: $Sprite2D_16.visible = true
    
    set_linear_velocity(Vector2(randf_range(-2.0, 2.0), 48 - size*2))

func get_fucking_lasered(delta):
    health -= delta * 16.0
    if health <= 0.0:
        die()

func die():
    $CollisionShape2D.set_deferred("disabled", true)
    $Sprites_8px.visible = false
    $Sprite2D_12.visible = false
    $Sprite2D_16.visible = false
    $GPUParticles2D.emitting = true
    $Sfx.get_children().pick_random().play()
    $AfterDeathTimer.start()

# todo:
# - get spawned randomly 
# - dink sound on bounce MEH
# - takes damage YEAH
# - can be exploded HELL YEAH
# 


func _on_timer_timeout() -> void:
    die()


func _on_after_death_timer_timeout() -> void:
    queue_free()
