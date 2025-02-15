class_name BeamClass
extends AnimatableBody2D

# TODO:
# Make missile a subclass of this
# Make ice beam, wave beam

var LIFESPAN: float = 1.0 / 12.0;
var lifetime: float = 0.0;

var dietime: float = 2.0; # timer after death to allow sounds, trails, etc. to finish

var velocity: Vector2
var ice: bool = true;
var damage: int = 1;
var create_sounds: Array;
var active: bool = true;
var CreateOnDie = null; #preload("res://Scenes/BigExplosion.tscn")


func _ready() -> void:
	create_sounds = $CreateSounds.get_children()
	if len(create_sounds) > 0:
		create_sounds.pick_random().play()
	add_to_group("beam")


func _process(delta: float) -> void:
	if !active:
		dietime -= delta
		if dietime <= 0:
			queue_free()

func _physics_process(delta: float) -> void:
	if lifetime > LIFESPAN:
		die()
	lifetime += delta
	var collision = move_and_collide(velocity * delta)
	if collision != null and active:
		if collision.get_collider().is_in_group("hatch"):
			collision.get_collider().get_parent().open()
		die()

	
func die():
	active = false
	$AreaToCheckForEnemy.set_deferred("disabled", true)
	$AreaToCheckForEnemy.set_deferred("monitoring", false)
	$AreaToCheckForEnemy.set_deferred("monitorable", false)
	$AreaToCheckForEnemy/CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	$CPUParticles2D_Trail.emitting = false
	# todo - this is the wrong way to do it; sound player stops on destruction
	# maybe different things have a sound to play when a beam hits it
	#$Sounds/Hit.play()
	if CreateOnDie != null:
		var blam = CreateOnDie.instantiate()
		blam.position = Vector2(0,0)#global_position
		add_child(blam)


func _on_area_to_check_for_enemy_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		var enemy = area.get_parent()
		enemy.hurt(damage)
		die()
