extends CPUParticles2D


var time = 0
var collision_lifespan = .25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    emitting = true
    [$Explode1, $Explode2, $Explode3, $Explode4][randi() % 4].play()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    time += delta
    pass


func _on_finished() -> void:
    queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
    if area.is_in_group("enemies") and time < collision_lifespan:
        # todo: This should take damage, cooldown, etc.
        area.get_parent().hurt(10, .25)
        print("Missile hit an enemy!")
