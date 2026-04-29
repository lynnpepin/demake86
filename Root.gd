extends Node2D

var planetsplode = preload("res://Scenes/Screens/PlanetSplode.tscn")

func vshake_player_camera(strength: float, KK=8.0, DD=16.0):
    $Relan/CameraAnchor/Camera2D.vshake(strength, KK, DD)

# todo - decrease shake by distance?

func shake_player_camera(
    strength: Vector2,
    KK = [8.0, 2.0],
    DD = [16.0, 8.0]
):
    $Relan/CameraAnchor/Camera2D.set_shake(strength, KK, DD)

func planet_splode(relan_escape: bool = false):
    #get_tree().change_scene_to_node(planetsplode)
    get_tree().change_scene_to_file("res://Scenes/Screens/PlanetSplode.tscn")
    print("THIS SHOULD NOT HAPPEN!!!!!!!!!!!!!")
