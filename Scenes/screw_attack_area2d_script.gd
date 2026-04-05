extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # i forget what group "beam" does...
    add_to_group("beam")




func _on_area_entered_to_check_for_enemies(area: Area2D) -> void:
    if area.is_in_group("enemies"):
        var enemy = area.get_parent()
        enemy.hurt(86, 0.1986)
