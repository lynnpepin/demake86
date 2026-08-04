extends Node2D

var PlanetSplode = preload("res://Scenes/Screens/PlanetSplode.tscn")
#var BeamShot = preload("res://Classes/BeamClass.tscn")

var also_tracking_position: Vector2
var also_tracking_thatcher: bool = false


func _ready() -> void:
    Global.game_timer = 0.0

func vshake_player_camera(strength: float, KK=8.0, DD=16.0):
    $CameraAnchor/Camera2D.vshake(strength, KK, DD)

# todo - decrease shake by distance?

func shake_player_camera(
    strength: Vector2,
    KK = [8.0, 2.0],
    DD = [16.0, 8.0]
):
    $CameraAnchor/Camera2D.set_shake(strength, KK, DD)

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
    if also_tracking_thatcher:
        var ratio_to_relan = .75
        var start_length = 64
        var end_length = 32
        
        var center_length_to_relan = (
            $Relan.position - also_tracking_position
        ).length()
        
        if center_length_to_relan > start_length:
            ratio_to_relan = 1.0
        elif center_length_to_relan > end_length:
            # for smoothly entering / exiting
            ratio_to_relan = remap(center_length_to_relan,
                end_length, start_length, ratio_to_relan, 1.0)
            
        $CameraAnchor.position = (
            $Relan.position * ratio_to_relan
            + also_tracking_position * (1 - ratio_to_relan)
        )
    else:
        $CameraAnchor.position = $Relan.position
    pass
    
func _process(delta: float) -> void:
    Global.game_timer += delta


func reset_shake():
    $CameraAnchor/Camera2D.reset_shake()

func _on_camera_zone_thatcher_area_entered(area: Area2D) -> void:
    also_tracking_thatcher = true
    reset_shake()
    also_tracking_position = $Tourian/camera_zone_thatcher.position
    pass # Replace with function body.

func _on_camera_zone_thatcher_area_exited(area: Area2D) -> void:
    also_tracking_thatcher = false
    reset_shake()
    pass # Replace with function body.


func _on_screenshot_timer_timeout() -> void:
    pass # Replace with function body.
