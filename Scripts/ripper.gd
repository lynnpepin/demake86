extends CharacterBody2D
# TODO: Get into the "shape" we want for enemy

#region variables
## The speed the Ripper moves with.
@export var speed = 24

## The amount of damage this can take
@export var health: int = 1_000_000

## The amount of damage the Ripper deals to players on collision
@export var damage_to_deal: int = 1

## The amount of time (in seconds) players are invincible after being hit by the Ripper
@export var invincibility_to_deal: float = 1

## The name of the guy :3
@export var nickname: String = "Ripper"


# Internal vars
var direction = 1
var hit_sounds: Array
var death_sounds: Array
# Called when the node enters the scene tree for the first time.
#endregion

func _ready() -> void:
	add_to_group("enemies")
	hit_sounds = $HitSounds.get_children()
	death_sounds = $DeathSounds.get_children()
	
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(delta * Vector2(speed * direction, 0))
	if collision:
		direction *= -1


func hurt(damage: int) -> void:
	print(nickname, " was hit with, ", damage, " points of damage.")
	hit_sounds.pick_random().play()
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	# todo
	# disable, make particle explosionm, play death sound, queue_free() once all are done
	#if len(death_sounds) > 0:
	#	hit_sounds.pick_random().play()
	pass


func _on_area_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().hurt(
			damage_to_deal,
			invincibility_to_deal
		)
