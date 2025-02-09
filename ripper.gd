extends CharacterBody2D


var speed = 24
var direction = 1
var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	add_to_group("enemies")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(delta * Vector2(speed * direction, 0))
	if collision:
		direction *= -1

func hurt(damage: int) -> void:
	#[$Sounds/Hit1, $Sounds/Hit2, $Sounds/Hit3][random.randi() % 3].play()
	$Sounds/Hit4.play()
	print("Ripper was hit with ", damage, "pts!")


func _on_area_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().hurt(1, 0.05)
	elif area.is_in_group("beam"):
		hurt(3)
