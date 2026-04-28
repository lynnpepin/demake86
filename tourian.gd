extends Node2D


@export var player: Node2D

var escape_started = false
var escape_time    = 24.0

func tourian_base_to_battle():
    $TileMapLayer_Tourian_Base.enabled = false
    $TileMapLayer_Tourian_Battle.enabled = true

func tourian_activate_escape_layout():
    $TileMapLayer_Tourian_Base.enabled = false
    $TileMapLayer_Tourian_Battle.enabled = false
    $TileMapLayer_Tourian_Escape.enabled = true

func start_escape():
    $StartEscape.play("StartEscape")
    # HACKY HACKY
    player.Typer.start("TIMEBOMB SET\nGET OUT FAST")
    escape_started = true
    player.escape_time_set(19.86)
    # todo play music

func _process(delta):
    if escape_started:
        escape_time -= delta
        player.escape_time_set(min(escape_time, 19.86))
