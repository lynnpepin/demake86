# TODO; no idea how to do this

extends AnimatableBody2D

var LIFESPAN: float = 1.0 / 12.0;
var lifetime: float = 0.0;
var velocity: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create()
	add_to_group("beam")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if lifetime > LIFESPAN:
		die()
	lifetime += delta
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		if collision.get_collider().is_in_group("hatch"):
			collision.get_collider().get_parent().open()
		die()
	# https://stackoverflow.com/questions/69728827/how-do-i-detect-collisions-in-godot#69731270
	
	#position += velocity * delta

func beam_hits_enemy():
	pass

func create():
	[$Sounds/Create, $Sounds/Create2, $Sounds/Create3, $Sounds/Create4][randi() % 4].play()
	
func die():
	# todo - this is the wrong way to do it; sound player stops on destruction
	# maybe different things have a sound to play when a beam hits it
	#$Sounds/Hit.play()
	queue_free()


func _on_area_to_check_for_enemy_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		# todo: This should take damage, cooldown, etc.
		area.get_parent().hurt(1)
		die()


# TODO:
# [x] sprite
# [x] collision shape for enemies, and for walls
# [x] dies when hit walls
# - explodes when it hits walls
# [x] shoot at angle
# [x] sounds when made
# [ ] Connect Signals so it can hit/kill ripper
# - sounds while moving
# - sound for when it times out
# - sounds when it hits wall
# - sounds when it hits enemy
# - sounds when it hits invulnerable enemy
# - subclass for missile, long beam, wave beam, ice beam
