extends BeamClass

func _ready() -> void:
    add_to_group("missile")
    #dietime = 12.0 # not what i need to let particles finish
    super()
    
    
    

func _on_area_entered(area: Area2D) -> void:
    #print("MISSILE ENTERED AREA OF TYPE: ", area.get_groups())

    if area.is_in_group("ventilated_area"):
        if $CPUParticles2D_Trail:
            $CPUParticles2D_Trail.speed_scale = 12.0
            $CPUParticles2D_Trail.fixed_fps = 60.0
            $CPUParticles2D_Trail.modulate = Color(1.0, 1.0, 1.0, .5)
            #$CPUParticles2D_Trail.lifetime /= 1.5
