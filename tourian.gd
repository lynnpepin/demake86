extends Node2D


@export var player: Node2D
var Setona = preload("res://Scenes/Enemies/SETONA.tscn")

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
    $EscapeEmbers_Shaft.emitting = true
    $StartEscape.play("StartEscape")
    # Disable sniping cheetos during escape
    for sniper in [
        $RinkoSniper, $RinkoSniper2, $RinkoSniper3, $RinkoSniper4,
        $RinkoSniper5, $RinkoSniper6, $RinkoSniper7, $RinkoSniper8]:
            if sniper:
                sniper.tracking_distance = 0.0
                sniper.tracking = null
                sniper.line.set_point_position(
                1,
                Vector2(0, 0)
            )
    # HACKY HACKY
    #player.Typer.start("TIMEBOMB SET\nGET OUT FAST")
    escape_started = true
    #player.escape_time_set(19.86)
    player._thatcher_dead()
    # todo play music
    # TODO - Relan modulate
    
    if $Setona:
        $Setona.queue_free()
    
    # hacky hacky - and why won't it work?
    var new_setona = Setona.instantiate()
    new_setona.name = "Setona2"
    add_child(new_setona)
    #$place_to_spawn_new_setona.get_parent().add_child(new_setona)
    #add_child(new_setona)
    $Setona2.position = $place_to_spawn_new_setona.position
    $Setona2.health = 1986
    $Setona2.strike_distance = 8.0
    $Setona2.visible = true
    $Setona2.tracking = player
    # why can't i see it? why does it not strike?
    print("NEW SETONA: ", $Setona2.global_position, $Setona2.position)

func _process(delta):
    if escape_time <= 0.5:
        $fade_to_white.modulate = Color(1.0, 1.0, 1.0, (.5 - escape_time) / .5);
    if escape_time <= 0:
        get_parent().planet_splode(false)
    if escape_started:
        var adjdelta = delta
        if escape_time < .01:
            adjdelta = delta / 1000
        elif escape_time < .1:
            adjdelta = delta / 100
        elif escape_time < 1:
            adjdelta = delta / 10
        elif escape_time < 2:
            adjdelta = delta / 6
        elif escape_time < 3:
            adjdelta = delta / 4
        elif escape_time < 4:
            adjdelta = delta / 3
        elif escape_time < 6:
            adjdelta = delta / 2
        elif escape_time < 12:
            adjdelta = delta / 1.5
        escape_time -= adjdelta
        player.escape_time_set(min(escape_time, 19.86))
