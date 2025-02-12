extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("player"):
			print("Tada")
			body.has_morph_ball = true
			body.show_message("CRAWL BALL\nACQUIRED")
			queue_free()
			# TODO - Make noise
