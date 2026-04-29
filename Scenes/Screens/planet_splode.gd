extends Node2D

@export var relan_escape: bool = false

func _ready() -> void:
    if relan_escape:
        $Meteoroid/RelanEscape.emitting = relan_escape
