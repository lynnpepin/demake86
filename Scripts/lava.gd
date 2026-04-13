extends Node2D

var hurt_value: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


#
#func _on_area_entered(area: Area2D) -> void:
    #if area.is_in_group("player"):
        #area.get_parent().hurt(1, 2)
