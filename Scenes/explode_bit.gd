extends RigidBody2D

@onready var exploded = false
var setforce = 86.19

func explode(force=setforce):
    if not exploded:
        print("BLAM")
        exploded = true
        pass
        apply_impulse(
            Vector2(randf() * force, randf() * force),
        )
        apply_torque(force * randf())
        # explode up mostly
        apply_impulse(
            Vector2(0, force)
        )
