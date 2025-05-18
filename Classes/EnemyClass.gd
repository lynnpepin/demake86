class_name EnemyClass
extends CharacterBody2D

# TODO:
# - Freeze sounds
# - Implement ice beam
# - Test unfreezing

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
@export var nickname: String = "Some Guy"

var hit_sounds: Array
var death_sounds: Array
var freeze_timer: float = 0.0
var hurt_timer: float = 0.0
# Called when the node enters the scene tree for the first time.
#endregion

func _ready() -> void:
	add_to_group("enemies")
	unfreeze()
	hit_sounds = $HitSounds.get_children()
	death_sounds = $DeathSounds.get_children()
	
func _process(delta: float) -> void:
	# Handle freeze timing
	if freeze_timer > 0 and health > 0:
		freeze_timer -= delta
		if freeze_timer <= 1:
			$AnimatedSprite2D.speed_scale = 1.0 - freeze_timer; # bring sprite back to speed
			if not $UnfreezeSound.playing:
				$UnfreezeSound.play()
			var freeze_vis_percent = floor((1 - freeze_timer) * 8) / 8.0
			$AnimatedSprite2D.modulate = Color(
				floor(152 + 103 * freeze_vis_percent) / 255.0,
				floor(220 + 35 * freeze_vis_percent) / 255.0,
				255 / 255.0
			)
			$Sprite2D_freeze_box.modulate = Color(1.0, 1.0, 1.0, 1 - freeze_vis_percent)
		if freeze_timer <= 0:
			freeze_timer = 0
			unfreeze()
	else:
		pass
		# todo - modulate damage color feedback
		#$AnimatedSprite2D.modulate(
		#	255 / 255.0,
		#	floor ()
		#)

func _physics_process(delta: float) -> void:
	pass

func hurt(damage: int) -> void:
	print(nickname, " was hit with, ", damage, " points of damage.")
	if len(hit_sounds) > 0:
		hit_sounds.pick_random().play()
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	unfreeze()
	freeze_timer = 0
	$DeathExplosion.emitting = true
	$AnimatedSprite2D.visible = false
	$CollisionPlatforming.set_deferred("disabled", true) 
	$AreaHitbox/CollisionShape2D.set_deferred("disabled", true)
	if len(death_sounds) > 0:
		hit_sounds.pick_random().play()
	$DeathExplosion.emitting = true
	# no freeze box
	# TODO: Worth deleting after sounds and emitter are done

func freeze(timer: float) -> void:
	if health > 0:
		$FreezeSound.play()
		freeze_timer = timer
		$AnimatedSprite2D.modulate = Color(152.0/255.0, 220.0/255.0, 255.0/255.0)
		$AnimatedSprite2D.speed_scale = 0.0;
		$Sprite2D_freeze_box.visible = true
		$Sprite2D_freeze_box.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$CollisionPlatforming.set_deferred("disabled", true) 
		$AreaHitbox/CollisionShape2D.set_deferred("disabled", true)
		$StaticBody2D_Frozen/CollisionShape2D.set_deferred("disabled", false)

func unfreeze() -> void:
	$AnimatedSprite2D.modulate = Color.WHITE
	$Sprite2D_freeze_box.visible = false
	$CollisionPlatforming.set_deferred("disabled", false) 
	$AreaHitbox/CollisionShape2D.set_deferred("disabled", false)
	$StaticBody2D_Frozen/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.speed_scale = 1.0

func _on_area_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().hurt(
			damage_to_deal,
			invincibility_to_deal
		)
