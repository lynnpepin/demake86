extends Area2D

var LIFESPAN: float = 1.0 / 12.0;
var lifetime: float = 0.0;
var velocity: Vector2

var random = RandomNumberGenerator.new() # todo - put these in a parent somewhere

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if lifetime > LIFESPAN:
		die()
	lifetime += delta
	position += velocity * delta

func create():
	[$Sounds/Create, $Sounds/Create2, $Sounds/Create3, $Sounds/Create4][random.randi() % 4].play()
	
func die():
	# todo - this is the wrong way to do it; sound player stops on destruction
	# maybe different things have a sound to play when a beam hits it
	$Sounds/Hit.play()
	queue_free()

# TODO:
# - sprite
# - collision shape for enemies, and for walls
# - dies when hit walls
# - explodes when it hits walls
# - shoot at angle
# - sounds when made
# - sounds while moving
# - sound for when it times out
# - sounds when it hits wall
# - sounds when it hits enemy
# - sounds when it hits invulnerable enemy
# - subclass for missile, long beam, wave beam, ice beam
