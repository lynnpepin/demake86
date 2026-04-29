extends "res://Scenes/Screens/drift.gd"

func explode():
    $Sprite2D.visible = false
    $Sprite2D.visible = false
    $CPUParticles2D_BigExplosion.emitting = true
