extends Node2D

@export var player: Node2D
@export var connected_grave: Node2D
@export var root: Node2D

var tolls: int = 0
var dead: bool = false
var sfxs: Array[Node]

func _on_area_2d_eyes_hurtbox_area_entered(area: Area2D) -> void:
    if !dead:
        dead = true
        $AnimationPlayer.play("retreat!", 4, 1)
        $MainBody/Eyes.visible = false
        $AudioStreamPlayer2D_Dead.play()
        
        $Timer.start(6.9)

func _ready():
    sfxs = $Sfx.get_children()


func _on_bell_toll_timer_timeout() -> void:
    tolls += 1
    if tolls < 6:
        $Timer.start(3.0)
    elif tolls >= 6:
        if player:
            player.show_message("Kemp\ndefeated.")
    if connected_grave:
        connected_grave.activate()
    if root:
        root.shake_player_camera(Vector2(2*tolls,0.0))


func _on_garble_timer_timeout() -> void:
    if !dead:
        sfxs.pick_random().play()
        $GarbleTimer.start(randf_range(.0625, .75))
