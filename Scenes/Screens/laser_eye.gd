extends Node2D


@export var MAX_LENGTH: float = 48.0
@export var poll_for_vibe: bool = false

var length: float = 0.0    # length of laser; i.e. to raycast
var active: bool = false # are we shooting a laser or not

func _ready():
    deactivate()

func _physics_process(delta: float) -> void:
    if active:
        #print(".. phys process, is active,")
        if $RayCast2D.is_colliding():
            #print(".. .. raycast is colliding,")
            length = (global_position - $RayCast2D.get_collision_point()).length()
            $Line2D.set_point_position(1, Vector2(0, -length))
            $GPUParticles2D_hit.position.y = -length
            if poll_for_vibe:
                var major_vibe_strength = clamp(1 - length / 12.0, 0.0, 1.0)
                var minor_vibe_strength = clamp(1 - length / 64.0, 0.0, 1.0)
                Input.start_joy_vibration(
                    0, minor_vibe_strength, major_vibe_strength,
                    .25
                )
            var collider = $RayCast2D.get_collider()
            if collider.has_method("get_fucking_lasered"):
                collider.get_fucking_lasered(delta)

func activate():
    print("activate laser")
    active = true
    $GPUParticles2D_eye.emitting = true
    $GPUParticles2D_hit.emitting = true
    $Line2D.visible = true
    $AudioStreamPlayer2D.play(randf_range(0.0, 0.2))
    pass
    # visible line, visible particles
    # shake screen, vibrate controller, make noise

func deactivate():
    print("deactivate laser")
    active = false
    $GPUParticles2D_eye.emitting = false
    $GPUParticles2D_hit.emitting = false
    $Line2D.visible = false
    $AudioStreamPlayer2D.stop()
    pass
    # visible line, visible particles
    # shake screen, vibrate controller, make noise

func _input(event: InputEvent) -> void:
    # TODO - change all input to be handled in this way
    if event.is_action_pressed("pad_x"):
        activate()
    if event.is_action_released("pad_x"):
        deactivate()
