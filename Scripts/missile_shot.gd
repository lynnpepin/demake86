extends AnimatableBody2D

var LIFESPAN: float = 4.0;
var lifetime: float = 0.0;
var velocity: Vector2
var active = true

var BigExplosion = preload("res://Scenes/BigExplosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create()
	add_to_group("beam")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if lifetime > LIFESPAN:
		die()
	lifetime += delta
	var collision = move_and_collide(velocity * delta)
	if collision != null and active:
		if collision.get_collider().is_in_group("hatch"):
			collision.get_collider().get_parent().open()
		die()


func create():
	$Sounds/Create.play()
	
func die():
	$AreaToCheckForEnemy.set_deferred("disabled", true)
	$AreaToCheckForEnemy.set_deferred("monitoring", false)
	$AreaToCheckForEnemy.set_deferred("monitorable", false)
	$AreaToCheckForEnemy/CollisionShape2D.set_deferred("disabled", true)
	active = false
	$Sprite2D.visible = false
	$CPUParticles2D_Smoke.emitting = false
	# todo - this is the wrong way to do it; sound player stops on destruction
	# maybe different things have a sound to play when a beam hits it
	#$Sounds/Hit.play()
	var blam = BigExplosion.instantiate()
	blam.position = Vector2(0,0)#global_position
	add_child(blam)
	if lifetime > LIFESPAN:
		queue_free()



	#var b = BeamShot.instantiate()
	#var rawangle = -angle * PI / 4
	#b.velocity = Vector2(128.0, 0).rotated(rawangle)
	#b.position = get_shoot_xy(angle)#global_position + get_shoot_xy(angle)
	#b.rotation = rawangle
	#if long:
		#b.LIFESPAN = 2
	#owner.add_child(b)

func _on_area_to_check_for_enemy_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and active:
		# todo: This should take damage, cooldown, etc.
		area.get_parent().hurt(30)
		die()
