class_name PickupClass
extends Node2D


## Name for debugging
@export var pickup_name: String = "thingy";

## Message to dispaly on pickup
@export var pickup_message: String = "THINGY\nACQUIRED"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickup_message = pickup_message.replace("\\n", "\n")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#for body in $Area2D.get_overlapping_bodies():

func player_do(body) -> void:
	body.add_missiles(1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("got ", pickup_name)
		player_do(body)
		body.show_message(pickup_message)
		queue_free()
		# TODO - Make noise
