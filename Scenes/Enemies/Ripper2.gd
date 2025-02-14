extends EnemyClass

var direction: int = 1
func _ready():
	super()
	unfreeze()

func _physics_process(delta: float) -> void:
	position.y += delta / 4.0
	var collision = move_and_collide(delta * Vector2(speed * direction, 0))
	if collision:
		direction *= -1
