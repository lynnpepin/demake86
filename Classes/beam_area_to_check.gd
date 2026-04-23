extends Area2D

# CollisionShape_start is an extra colliding area at the start of the beam
# To fix a bug where Relan can't kill enemies overlapping with her.


var timer: float = 0.0

var max_time_for_start: float = .125

var already_set = false

func _physics_process(delta):
    if timer < max_time_for_start:
        timer += delta
    elif !already_set:
        already_set = true
        print("DISABLED") 
        $CollisionShape_Start.set_deferred("disabled", true)
