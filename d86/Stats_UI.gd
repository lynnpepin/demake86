extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var HP = 64
var HPMAX = 64

var BAT = 64
var BATMAX = 64

var AMMO = 8
var AMMOMAX = 8

var SHIELD = 32
var SHIELDMAX = 32

var STAM = 32
var STAMMAX = 32

var RAD_BASE = 48
var RAD_0  = 16 + RAD_BASE
var RAD_1  = 10 + RAD_BASE

var RAD_2  = 8 + RAD_BASE
var RAD_3  = 6 + RAD_BASE
var RAD_4  = 2 + RAD_BASE

var tt = 0
var font

# Called when the node enters the scene tree for the first time.
func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://2D_graphics/InputBold.ttf")
	font.size = 12

func _process(delta):
	#HP = HPMAX * $VSlider.value / $VSlider.max_value
	tt += delta
	HP =   (sin(tt) + 1)/2 * HPMAX
	BAT =  (sin(tt*3) + 1)/2 * BATMAX
	AMMO = (sin(tt*2) + 1)/2 * AMMOMAX
	SHIELD = (sin(tt*3) + 1)/2 * SHIELDMAX
	STAM = (sin(tt) + 1)/2 * STAMMAX
	update()

func draw_circle_arc_poly(
	center, inner_radius=24, outer_radius=32,
	angle_from=-120, angle_to=120,
	colors=PoolColorArray([Color('#ff8822')]),
	nb_points = 128
	):
	var points_arc = PoolVector2Array()
	#points_arc.push_back(center + Vector2(cos(angle_from), sin(angle_from)) * inner_radius )

	for ii in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + ii * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * inner_radius)
	
	for ii in range(nb_points + 1):
		var angle_point = deg2rad(angle_to + ii * (angle_from - angle_to) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * outer_radius)
		
	draw_polygon(points_arc, colors)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw():
	# stamina
	# angle: 130 + 100*(stam / max)  to 230
	var stam_norm = 100 * STAM / STAMMAX
	var center = self.position
	draw_circle_arc_poly(center, RAD_0, RAD_1, 130 + stam_norm, 230 , PoolColorArray([Color('#ccffcc')]))
	
	# shield
	var shield_norm = 100 * SHIELD / SHIELDMAX
	draw_circle_arc_poly(center, RAD_0, RAD_1, 250, 250 + shield_norm, PoolColorArray([Color('#ccccff')]))
	
	# ammo
	var ammo_norm = 100 * AMMO / AMMOMAX
	draw_circle_arc_poly(center, RAD_0, RAD_1, 10, 10 + ammo_norm, PoolColorArray([Color('#ffcc22')]))
	
	# health
	var hp_norm = 160 * HP / HPMAX
	draw_circle_arc_poly(center, RAD_2 - 1, RAD_4, -hp_norm, hp_norm, PoolColorArray([Color('#dd2244')]))
	
	# battery
	var bat_norm = 160 * BAT / BATMAX
	draw_circle_arc_poly(center, RAD_2, RAD_3, -bat_norm, bat_norm, PoolColorArray([Color('#ccddee')]))
	
	#draw_set_transform(Vector2(0,0), 90, Vector2(1,1))
	# draw SHLD
	var tang = deg2rad(-120) # temporary ang
	draw_set_transform(center, deg2rad(-90), Vector2(1,1))
	#draw_set_transform(center, 0, Vector2(1,1))
	#draw_string(font, Vector2(-72, 24), "SHLD")
	draw_string(font, Vector2(cos(tang) + .3, sin(tang))*(RAD_BASE + 32), "SHLD")
	
	# AMMO
	tang = deg2rad(-75 - 30)
	draw_set_transform(center, deg2rad(30), Vector2(1,1))
	draw_string(font, Vector2(cos(tang), sin(tang))*(RAD_BASE + 24), "AMMO")
	
	# (todo)
	# STAM
	draw_set_transform(center + Vector2(-62, 56), deg2rad(30), Vector2(1,1))
	draw_string(font, Vector2(0, 0), "STAM")
	
	draw_set_transform(center, deg2rad(0), Vector2(1,1))
