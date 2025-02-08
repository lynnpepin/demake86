extends CharacterBody2D


var speed = 16
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(delta * Vector2(speed * direction, 0))
	if collision:
		direction *= -1
