extends Node2D

func tourian_base_to_battle():
    $TileMapLayer_Tourian_Base.enabled = false
    $TileMapLayer_Tourian_Battle.enabled = true

func tourian_activate_escape_layout():
    $TileMapLayer_Tourian_Base.enabled = false
    $TileMapLayer_Tourian_Battle.enabled = false
    $TileMapLayer_Tourian_Escape.enabled = true
