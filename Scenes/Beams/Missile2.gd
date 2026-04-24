extends BeamClass


func _ready() -> void:
    super()
    
    

func _on_area_entered(area: Area2D) -> void:
    print("MISSILE ENTERED AREA OF TYPE: ", area.get_groups())
    if area.is_in_group("ventilated_area"):
        if $CPUParticles2D_Trail:
            $CPUParticles2D_Trail.speed_scale = 6.0
            $CPUParticles2D_Trail.lifetime /= 1.5
