extends EnemyClass

@onready var ray_see_left = $RayCast2D_see_left
@onready var ray_see_right = $RayCast2D_see_right
@onready var ray_attack_left = $RayCast2D_attack_left
@onready var ray_attack_right = $RayCast2D_attack_right

var col_see_left : Object
var col_see_right : Object
var col_attack_left : Object
var col_attack_right : Object

var opened = false
var falling = false
var drilling = false
var drill_timer = 0.0
var drill_max = 1.0

var MushroomExplosion = preload("res://Scenes/MushroomCloudExplosion.tscn")

func _process(delta: float) -> void:
    # todo:
    # open when you see relan, if is first collider
    col_see_left     = ray_see_left.get_collider()
    col_see_right    = ray_see_right.get_collider()
    col_attack_left  = ray_attack_left.get_collider()
    col_attack_right = ray_attack_right.get_collider()
    
    if !opened and !falling and !drilling and !frozen:
        if col_see_left != null:
            if col_see_left.is_in_group("player"):
                opened = true
                $AnimatedSprite2D.play("open")
                # todo - unique sound?
                $HitSounds/AudioStreamPlayer2D3.play()
    
        if col_see_right != null:
            if col_see_right.is_in_group("player"):
                opened = true
                $AnimatedSprite2D.play("open")
                $HitSounds/AudioStreamPlayer2D3.play()
                 
    if !falling and !drilling and !frozen:
        if col_attack_left != null:
            if col_attack_left.is_in_group("player"):
                falling = true
                $AnimatedSprite2D.play("drill")
                $HitSounds/AudioStreamPlayer2D.play()
    
        elif col_attack_right != null:
            if col_attack_right.is_in_group("player"):
                falling = true
                $AnimatedSprite2D.play("drill")
                $HitSounds/AudioStreamPlayer2D.play()
                
    if drilling and !frozen:
        drill_timer += delta
    
        if drill_timer >= drill_max:
            drilling = false
            var blam = MushroomExplosion.instantiate()
            blam.position.y += 4
            #blam.position = global_position
            add_child(blam) 
            blam.reparent(get_parent())
        
            die()
    super(delta)
    
    
func _physics_process(delta: float) -> void:
    super(delta)
    if falling and !frozen:
        var col = move_and_collide(Vector2(0,1)*delta*128)
        if col:
            move_and_collide(Vector2(0,0))
            falling = false
            drilling = true

func die():
    super()
