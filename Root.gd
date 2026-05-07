extends Node2D

var PlanetSplode = preload("res://Scenes/Screens/PlanetSplode.tscn")
#var BeamShot = preload("res://Classes/BeamClass.tscn")

func _ready() -> void:
    Global.game_timer = 0.0

func vshake_player_camera(strength: float, KK=8.0, DD=16.0):
    $Relan/CameraAnchor/Camera2D.vshake(strength, KK, DD)

# todo - decrease shake by distance?

func shake_player_camera(
    strength: Vector2,
    KK = [8.0, 2.0],
    DD = [16.0, 8.0]
):
    $Relan/CameraAnchor/Camera2D.set_shake(strength, KK, DD)

func planet_splode(
    relan_escape: bool = false,
):
    print("Root.gd:planet_splode(...)")

    var planetsplode = PlanetSplode.instantiate()
    #var b = BeamShot.instantiate()
    #b.ice = owner.has_ice_beam
    planetsplode.relan_escape = relan_escape
    get_tree().change_scene_to_node(planetsplode)

func _physics_process(delta: float) -> void:
    $Camera2D.global_position = $Relan.global_position
    pass
    
func _process(delta: float) -> void:
   
    Global.game_timer += delta
