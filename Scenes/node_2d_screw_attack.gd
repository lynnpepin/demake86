extends Node2D

var active = false

func _ready():
    off()

func on():
    active = true
    $Sprite2D.visible = true
    $Area2D.monitoring = true
    $Area2D.monitorable = true
    $SfxrStreamPlayer.playing = true

func off():
    active = false
    $Sprite2D.visible = false
    $Area2D.monitoring = false
    $Area2D.monitorable = false
    $SfxrStreamPlayer.playing = false
