extends Node2D

var time = 0
var lifespan = .25
var blasted_player = 0 #0: not blasted; 1: blasted this frame, 2: blasting is done, no more blasting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("... Bomb explosion started")
	#print("I am a bomb explosion!")
	$Explode.play()
	for effect: CPUParticles2D in [
		$CPUParticles2D_SmallExplosion_Ring,
		$CPUParticles2D_SmallExplosion_Directional0,
		$CPUParticles2D_SmallExplosion_Directional1,
		$CPUParticles2D_SmallExplosion_Directional2,
		$CPUParticles2D_SmallExplosion_Directional3,
		$CPUParticles2D_SmallExplosion_Directional4,
		$CPUParticles2D_SmallExplosion_Directional5,
		$CPUParticles2D_SmallExplosion_Directional6,
		$CPUParticles2D_SmallExplosion_Directional7,
		$CPUParticles2D_SmokePuff,
	]:
		effect.emitting = true
	#print("... Bomb explosion is ready for the big leagues!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	
	$hurtbox/CollisionShape2D.shape.radius = 4 + time * (1.0/lifespan) * 6 # start at 4px, grow +4px radius = 16px radius bomb!
	for body in $hurtbox.get_overlapping_bodies():
		if body.is_in_group("hatch"):
			body.get_parent().open()
		if body.is_in_group("level"):
			pass
			# todo - bomb blocks here!

	for body in $upbox.get_overlapping_bodies():
		if body.is_in_group("player") and blasted_player < 2:
			print("player entered upbox")
			blasted_player = 1
			# todo - should handle lava appropriately
			body.apply_impulse(Vector2(0, -128))
			# todo
	for body in $leftbox.get_overlapping_bodies():
		if body.is_in_group("player") and blasted_player < 2:
			print("player entered leftbox")
			blasted_player = 1
			body.apply_impulse(Vector2(-64, 0))
			# todo
	for body in $rightbox.get_overlapping_bodies():
		if body.is_in_group("player") and blasted_player < 2:
			print("player entered rightbox")
			body.apply_impulse(Vector2(64, 0))
			blasted_player = 1
			# todo
	if blasted_player == 1:
		blasted_player = 2
			

	if time >= lifespan:
		#print("... The bomb explosion is done, bye!")
		queue_free()
	time += delta

func _exit_tree() -> void:
	print("... Bomb explosion gone after ", time, " secs")

#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("enemies"):
		## todo: This should take damage, cooldown, etc.
		#area.get_parent().hurt(2)
		#print("Bomb hit an enemy!")
#
#
#
#func _on_upbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player"):
		#print("player entered bomb up blast")
#
#
#func _on_rightbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player"):
		#print("player entered bomb right blast")
#
#
#func _on_leftbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player"):
		#print("player entered bomb left blast")
