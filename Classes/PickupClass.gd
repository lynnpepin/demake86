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
        $Area2D.set_deferred("monitoring", false)
        $Area2D.set_deferred("monitorable", false)
        print("got ", pickup_name)
        player_do(body)
        body.show_message(pickup_message)
        # HACKY angels!! 
        # I don't know why these nodes don't inherit across PickupClass es
        # but it's cheap n ez enough to copy to all of them 
        $Timer.start(3.6)
        for child in get_children():
            if "visible" in child:
                child.visible = false
        $angel_1.visible = true
        $angel_2.visible = true
        $AudioStreamPlayer2D.play()


func _on_timer_timeout() -> void:
    queue_free()
