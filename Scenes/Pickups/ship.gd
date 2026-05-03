extends Node2D

var timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    $SubViewport/Node3D/PivotLight1.rotate_y(delta)

func _physics_process(delta: float) -> void:
    timer += delta
    position.y += sin(timer * PI / 3.0) / 86.0
    $SubViewport/Node3D/crowskull2.rotate_y(
        cos(timer * PI / 4.0 ) / 720.0
    )


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"): # Replace with function body.
        # NOT THE WAY TO DO THIS
        get_parent().get_parent().planet_splode(true)
        print("ship entered")
