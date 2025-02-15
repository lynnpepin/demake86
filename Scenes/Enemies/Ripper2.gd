extends EnemyClass

var direction: int = 1
func _ready():
	super()
	freeze(3)

func _physics_process(delta: float) -> void:
	if freeze_timer <= 0:
		var collision = move_and_collide(delta * Vector2(speed * direction, 0))
		if collision:
			direction *= -1
