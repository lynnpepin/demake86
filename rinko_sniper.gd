
extends Node2D

@export var tracking: Node2D
@export var tracking_distance: float = 36.0
@export var color: Color = Color("#25E2CD")

@export var SHOOT_PERIOD: float = 3.0
var shoot_timer = 0.0

var Cheerio = preload("res://Scenes/Enemies/cheerio.tscn")

@export var angle: float:
    get:
        return angle
    set(new_angle):
        angle = new_angle
        if $AnimatedSprite2D:
            $AnimatedSprite2D.rotation = angle * PI / 180

func _ready() -> void:
    $AnimatedSprite2D.rotation = angle * PI / 180
    $Line2D.points = PackedVector2Array(
        [Vector2(0,0), Vector2(0,0)]
    )
    $Line2D.default_color = color

func _process(delta):
    # flip to face Relan when she is out of view
    if tracking:
        # if in of range,
        if global_position.distance_to(tracking.global_position) <= tracking_distance:
            if shoot_timer == 0.0:
                $ChargeSfx.play()
            shoot_timer += delta
            $Line2D.points[1] = tracking.global_position - global_position;
            $Line2D.modulate = Color(1, 1, 1, shoot_timer / SHOOT_PERIOD);
            if shoot_timer >= SHOOT_PERIOD:
                shoot_timer = 0.0
                var cheerio = Cheerio.instantiate()
                cheerio.position = global_position
                cheerio.velocity = 48.0
                cheerio.direction = $Line2D.points[1].normalized()
                owner.add_child(cheerio)
                # todo - shoot
        else:
            $ChargeSfx.stop()
            $Line2D.points[1] = Vector2(0,0)
            shoot_timer = 0.0
