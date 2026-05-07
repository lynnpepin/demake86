extends Node2D


@export var player: Node2D

var escape_started = false
var escape_time    = 30.0

func tourian_base_to_battle():
    $TileMapLayer_Tourian_Base.enabled = false
    $TileMapLayer_Tourian_Battle.enabled = true

func tourian_activate_escape_layout():
    $TileMapLayer_Tourian_Base.enabled = false
    $TileMapLayer_Tourian_Battle.enabled = false
    $TileMapLayer_Tourian_Escape.enabled = true

func start_escape():
    $EscapeEmbers.emitting = true
    $StartEscape.play("StartEscape")
    $RinkoSniper.tracking_distance = 0.0
    $RinkoSniper2.tracking_distance = 0.0
    $RinkoSniper3.tracking_distance = 0.0
    $RinkoSniper4.tracking_distance = 0.0
    $RinkoSniper5.tracking_distance = 0.0
    $RinkoSniper6.tracking_distance = 0.0
    $RinkoSniper7.tracking_distance = 0.0
    $RinkoSniper8.tracking_distance = 0.0
    # HACKY HACKY
    #player.Typer.start("TIMEBOMB SET\nGET OUT FAST")
    escape_started = true
    #player.escape_time_set(19.86)
    # todo play music

func _process(delta):
    if escape_time <= 0.5:
        $fade_to_white.modulate = Color(1.0, 1.0, 1.0, (.5 - escape_time) / .5);
    if escape_time <= 0:
        get_parent().planet_splode(false)
    if escape_started:
        var adjdelta = delta
        if escape_time < .1:
            adjdelta = delta / 100
        if escape_time < .5:
            adjdelta = delta / 10
        elif escape_time < 1:
            adjdelta = delta / 8
        elif escape_time < 2:
            adjdelta = delta / 6
        elif escape_time < 3:
            adjdelta = delta / 4
        elif escape_time < 6:
            adjdelta = delta / 2
        escape_time -= adjdelta
        player.escape_time_set(min(escape_time, 19.86))
