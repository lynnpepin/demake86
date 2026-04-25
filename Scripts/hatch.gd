extends Node2D


@export var tracking: Node2D
@export var tracking_another: Node2D
@export var tracking_third: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.



func open():
    $OpenSound.play()
    $AnimatedSprite2D.play("open")
    $StaticBody2D.queue_free()
    if tracking:
        tracking.unveil()
    if tracking_another:
        tracking_another.unveil()
    if tracking_third:
        tracking_third.unveil()

    
# TODOs:
# - Open
# - Play sound on open
# 
