extends Node2D

@export var visible_on_ready: bool = true

func _ready():
    visible = visible_on_ready
    for child in get_children():
        child.visible = true
