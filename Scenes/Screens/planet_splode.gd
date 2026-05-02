extends Node2D

@export var relan_escape: bool = false
@export var secret_ending_minigame: bool = false
var death = preload("res://Scenes/game_over_restart.tscn")

func _ready() -> void:
    $Meteoroid/RelanEscape.emitting = relan_escape
    $Meteoroid/RelanEscape.visible = relan_escape

func next_scene() -> void:
    if not relan_escape:
        get_tree().change_scene_to_file("res://Scenes/game_over_restart.tscn")
    elif secret_ending_minigame:
        pass
        # TODO
    else:
        pass
        # TODO
