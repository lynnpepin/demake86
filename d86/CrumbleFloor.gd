extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var crumble_timer = 0
var respawn_timer = 0

var crumbled = false
var TIME_UNTIL_CRUMBLE = 1/2
var TIME_UNTIL_RESPAWN = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_crumble():
	$Sprite.modulate = Color(1,0,0)
	
func set_respawn():
	$Sprite.modulate = Color(0,1,1)

func _process(delta):
	if not crumbled:
		if crumble_timer < 0:
			crumbled = true
			crumble_timer = TIME_UNTIL_CRUMBLE
			respawn_timer = TIME_UNTIL_RESPAWN
		
		if len($Area2D.get_overlapping_bodies()) > 1:
			crumble_timer -= delta
		else:
			crumble_timer = TIME_UNTIL_CRUMBLE
	
	else: # crumbled
		if respawn_timer < 0:
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
