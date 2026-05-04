class_name BeamClass
extends AnimatableBody2D

# TODO:
# Make missile a subclass of this
# Make ice beam, wave beam


## Time in seconds for this beam to exist
@export var LIFESPAN: float = 1.0 / 9.0;

var lifetime: float = 0.0;

## Time in seconds to let sounds and particles finish up
@export var dietime: float = 6.0; # timer after death to allow sounds, trails, etc. to finish

var angle: float
var velocity: Vector2


## Amount of damage for this beam to deal
@export var damage: int = 1;
@export var damage_cooldown: float = .125;
var create_sounds: Array;
var hit_sounds: Array;
var active: bool = true;

## Explosion (or other) node to create once this one explodes and dies
@export var CreateOnDie: PackedScene = preload("res://Scenes/Hitmarker.tscn"); #preload("res://Scenes/BigExplosion.tscn")
var WaveHitmarker: PackedScene = preload("res://Scenes/Hitmarker_Wave.tscn");
var IceHitmarker: PackedScene = preload("res://Scenes/Hitmarker_Ice.tscn");

var preloaded_CreateOnDie: Node2D = null;

# Total height to move up in a sinusoidal pattern
@export var amplitude: float = 0.0;
@export var frequency: float = 0.0;
@export var phase_angle: float = 0;
var offset: Vector2 = Vector2(0,0);

var ice: bool = false
var wave: bool = false


func _ready() -> void:
    create_sounds = $CreateSounds.get_children()
    hit_sounds = $HitSounds.get_children()
    
    if len(create_sounds) > 0:
        create_sounds.pick_random().play()
    add_to_group("beam")
    
    if ice and wave:
        $Sprite2D.modulate = Color(255.0/255.0, 128.0/255.0, 512.0/255.0)
        $Trail_Waveicebeam.emitting = true
        #$Trail_Wavebeam.emitting = true
        #$Trail_Icebeam.emitting = true
    elif wave:
        $Trail_Wavebeam.emitting = true
        $Sprite2D.modulate = Color(255.0/255.0, 64.0/255.0, 255.0/255.0)
    elif ice:
        $Sprite2D.modulate = Color(152.0/255.0, 220.0/255.0, 255.0/255.0)
        $Trail_Icebeam.emitting = true
    else:
        $CPUParticles2D_Trail.emitting = true


func _process(delta: float) -> void:
    if !active:
        dietime -= delta
        if dietime <= 0:
            queue_free()

func _physics_process(delta: float) -> void:
    if lifetime > LIFESPAN:
        die()
    
    lifetime += delta
     
    # TODO - Figure out raw rotations
    velocity += Vector2(
        0,
        amplitude * cos((lifetime + phase_angle) * PI * 2 * frequency)
    ).rotated(angle)
    
    # TODO: make this work for other angles too
    
    var collision = move_and_collide(velocity * delta)
    if collision != null and active:
        die()
        if len(hit_sounds) > 0:
            hit_sounds.pick_random().play()
        # bad hacks here
        if is_in_group("missile"):
            if collision.get_collider().is_in_group("tourian_barrier"):
                collision.get_collider().get_hit_by_missile()
                die()
        if collision.get_collider().is_in_group("hatch"):
            collision.get_collider().get_parent().open()
        if collision.get_collider().is_in_group("shootable_block"):
            collision.get_collider().shot()

    
func die():
    if active:
        active = false
        disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
        $AreaToCheckForEnemy.set_deferred("disabled", true)
        $AreaToCheckForEnemy.set_deferred("monitoring", false)
        $AreaToCheckForEnemy.set_deferred("monitorable", false)
        $AreaToCheckForEnemy/CollisionShape2D.set_deferred("disabled", true)
        if $AreaToCheckForEnemy/CollisionShape_Start:
            $AreaToCheckForEnemy/CollisionShape_Start.set_deferred("disabled", true)
        $AreaToCheckForEnemy.queue_free()
    
        $ColliderWall.set_deferred("monitoring", false)
        $ColliderWall.set_deferred("monitorable", false)
        $ColliderWall.set_deferred("disabled", false)
        $ColliderWall.queue_free()
        $Sprite2D.visible = false
        $CPUParticles2D_Trail.emitting = false
        if $Trail_Longbeam:
            $Trail_Longbeam.emitting = false
            $Trail_Icebeam.emitting = false
            $Trail_Wavebeam.emitting = false
            $Trail_Waveicebeam.emitting = false
        # todo - this is the wrong way to do it; sound player stops on destruction
        # maybe different things have a sound to play when a beam hits it
        
        # create on die
        if wave:
            var blam = WaveHitmarker.instantiate()
            blam.position = Vector2(0,0)#global_position
            add_child(blam)
        if ice:
            var blam = IceHitmarker.instantiate()
            blam.position = Vector2(0,0)#global_position
            add_child(blam)
        if !wave and !ice and CreateOnDie != null:
            var blam = CreateOnDie.instantiate()
            blam.position = Vector2(0,0)#global_position
            add_child(blam)


func _on_area_to_check_for_enemy_area_entered(area: Area2D) -> void:
    if active:
        if area.is_in_group("enemies"):
            if len(hit_sounds) > 0:
                hit_sounds.pick_random().play()
            var enemy = area.get_parent()
            var is_frozen = enemy.freeze_timer > 0
            enemy.hurt(damage, damage_cooldown)
            if ice and not is_frozen:
                enemy.freeze(6)
            die()
