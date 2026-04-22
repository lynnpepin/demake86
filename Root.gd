extends Node2D

func vshake_player_camera(strength: float, KK=8.0, DD=16.0):
    $Relan/Camera2D.vshake(strength, KK, DD)

# todo - decrease shake by distance?

func shake_player_camera(
    strength: Vector2,
    KK = [8.0, 2.0],
    DD = [16.0, 8.0]
):
    $Relan/Camera2D.set_shake(strength, KK, DD)
