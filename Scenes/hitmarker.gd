extends Node2D

var timer = 0.0

func _ready():
    $Pew.emitting = true
    $Pew2.emitting = true
    $Pew3.emitting = true
    $Pew4.emitting = true

func _process(delta):
    timer += delta
    if timer >= .5:
        queue_free()
