extends Node2D

var active = false

func on():
    active = true
    $Sprite2D.visible = true
    $Area2D.monitoring = true
    $SfxrStreamPlayer.playing = true


func off():
    active = false
    $Sprite2D.visible = false
    $Area2D.monitoring = false
    $SfxrStreamPlayer.playing = false
