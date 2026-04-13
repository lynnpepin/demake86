@tool
extends Node2D
var hurt_value: int = 1

@export var size := Vector2(8, 8) : set = _set_size  # syntax for setter function
var collision_offset = 2

func _ready():
    _update_collision()

func _process(delta):
    pass

func _set_size(new_size: Vector2) -> void:
    size = new_size
    _update_collision()

func _update_collision():
    pass
    #var CollisionShape2D = $Area2D/CollisionShape2D
    #var r = RectangleShape2D.new()
    #r.size = size - Vector2(collision_offset * 2, collision_offset * 2)
    #CollisionShape2D.shape = r
    #CollisionShape2D.position = size / 2 
    
#
#func _on_area_entered(area: Area2D) -> void:
    #if area.is_in_group("player"):
        #area.get_parent().hurt(1, 2)
