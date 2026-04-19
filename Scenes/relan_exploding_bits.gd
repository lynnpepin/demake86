extends Node2D

func explode():
    $Cannon.explode()
    $Leg_Left.explode()
    $Leg_Right.explode()
    $Torso.explode()
    $Helmet.explode()
