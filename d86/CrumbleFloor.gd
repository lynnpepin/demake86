#extends StaticBody2D
extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var crumble_timer = 0
var respawn_timer = 0

var crumbled = false
var TIME_UNTIL_CRUMBLE = 1.0 / 30.0
var TIME_UNTIL_RESPAWN = 1.00


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_crumble():
	$Sprite.modulate = Color(1,0,0)
	$CollisionShape2D.disabled = true
	
func set_respawn():
	$Sprite.modulate = Color(0,1,1)
	$CollisionShape2D.disabled = false

func _process(delta):
	if not crumbled:
		if crumble_timer < 0:
			crumbled = true
			crumble_timer = TIME_UNTIL_CRUMBLE
			respawn_timer = TIME_UNTIL_RESPAWN
		
		# $Area2D is the area that detects the player on top
		if len($Area2D.get_overlapping_bodies()) > 1:
			crumble_timer -= delta
		else:
			crumble_timer = TIME_UNTIL_CRUMBLE
	
	else: # crumbled
		if respawn_timer < 0:
			# $body_area is the area that detects the player inside
			if len($body_area.get_overlapping_bodies()) < 1:
				crumbled = false
				crumble_timer = TIME_UNTIL_CRUMBLE
				respawn_timer = TIME_UNTIL_RESPAWN
				
		if len($Area2D.get_overlapping_bodies()) > 1:
			respawn_timer = TIME_UNTIL_RESPAWN
		else:
			respawn_timer -= delta
	
	if crumbled:
		set_crumble()
	else:
		set_respawn()
