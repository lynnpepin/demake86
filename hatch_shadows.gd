extends Node2D

func _ready():
    #visible = true
    for child in get_children():
        child.visible = true
