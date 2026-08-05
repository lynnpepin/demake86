extends Node2D

@export var relan_escape: bool = false
var death = preload("res://Scenes/Screens/game_over_restart.tscn").instantiate()
var credits = preload("res://Scenes/Screens/Credits.tscn").instantiate()
var opossums_saved = 0

func _ready() -> void:
    $Meteoroid/RelanEscape.emitting = relan_escape
    $Meteoroid/RelanEscape.visible = relan_escape
    if opossums_saved >= 1:
        $Meteoroid/OpossumEscape1.emitting = true
    if opossums_saved >= 2:
        $Meteoroid/OpossumEscape2.emitting = true
    if opossums_saved >= 3:
        $Meteoroid/OpossumEscape3.emitting = true

func next_scene() -> void:
    if not relan_escape:
        get_tree().change_scene_to_node(death)    
        #get_tree().change_scene_to_file("res://Scenes/Screens/game_over_restart.tscn")
    else:
        if Global.game_timer <= 86.9:
            print("SECRET ENDING")
            pass # TODO secret ending
            get_tree().change_scene_to_node(credits)    
        else:
            print("CREDITS")
            get_tree().change_scene_to_node(credits)    
            
