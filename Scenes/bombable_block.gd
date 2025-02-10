extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_check_bomb_area_entered(area: Area2D) -> void:
	if area.is_in_group("bomb"):
		destroy()
		

func destroy() -> void:
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$area_check_bomb/CollisionShape2D.set_deferred("disabled", true)
	[$Destroy1, $Destroy2, $Destroy3][randi() % 3].play()
