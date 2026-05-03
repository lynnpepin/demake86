extends Node2D

@export var relan_escape: bool = false
var death = preload("res://Scenes/Screens/game_over_restart.tscn").instantiate()


func _ready() -> void:
    $Meteoroid/RelanEscape.emitting = relan_escape
    $Meteoroid/RelanEscape.visible = relan_escape

func next_scene() -> void:
    if not relan_escape:
        get_tree().change_scene_to_node(death)    
        #get_tree().change_scene_to_file("res://Scenes/Screens/game_over_restart.tscn")
    else:
        if Global.game_timer <= 86.9:
            print("SECRET ENDING")
            pass # TODO secret ending
        else:
            print("CREDITS")
            pass # TODO credits
