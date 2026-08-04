extends StaticBody2D

var crumbling = false
var recharging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    
    pass # Replace with function body.



func _physics_process(delta: float) -> void:
    if crumbling:
        if $AnimatedSprite2D.frame >= 3:
            crumbled()
    elif recharging:
        if $AnimatedSprite2D.frame >= 11:
            if $area_check_relan.has_overlapping_bodies():
                $AnimatedSprite2D.frame = 10
            else:
                recharge()   


#func _on_area_check_bomb_area_entered(area: Area2D) -> void:
#    if area.is_in_group("beam"):
#        print("beam area crumble")
#        print(area.get_parent().name)
#        crumble()
#    elif area.is_in_group("bomb"):
#        crumble()

func shot() -> void:
    print("shot fired")
    crumbling = true
    $AnimatedSprite2D.play("crumble")
    $CollisionShape2D.set_deferred("disabled", true)
    $area_check_beam/CollisionShape2D.set_deferred("disabled", true)
    [$Destroy1, $Destroy2, $Destroy3][randi() % 3].play()

func crumbled():
    $AnimatedSprite2D.play("recharge")
    recharging = true
    crumbling = false

func recharge() -> void:
    recharging = false
    crumbling = false
    $AnimatedSprite2D.play("default")
    $CollisionShape2D.set_deferred("disabled", false)
    $area_check_beam/CollisionShape2D.set_deferred("disabled", false)
    [$Destroy1, $Destroy2, $Destroy3][randi() % 3].play()


func _on_area_check_bomb_area_entered(area: Area2D) -> void:
    if area.is_in_group("bomb") or area.is_in_group("explosion"):
        shot()

# Hacky; turn this back on so bombs can get it too
#func _on_area_check_beam_body_entered(body: Node2D) -> void:
#    shot()
    #if body.is_in_group("beam"):
    #    print("beam body crumb")
    #    crumble()
    #elif body.is_in_group("bomb"):
    #    crumble()

# above doesn't work. Let's try again
