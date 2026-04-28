extends Node2D

func explode():
    for child in get_children():
        child.explode(198.6)
