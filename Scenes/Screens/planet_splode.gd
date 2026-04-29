extends Node2D

@export var relan_escape: bool = false

func _ready() -> void:
    $Meteoroid/RelanEscape.emitting = relan_escape
    $Meteoroid/RelanEscape.visible = relan_escape
