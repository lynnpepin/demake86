extends CPUParticles2D

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	[$Explode1, $Explode2, $Explode3, $Explode4][random.randi_range(0,3)].play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finished() -> void:
	queue_free()
