extends Area2D

# More reliable way to have one node track another.
# Assigned to Relan in Inspector
@export var tracking: Node2D
@export var tracking_distance: float

var fallen: bool = false

func _process(delta):
    # flip to face Relan when she is out of view
    if tracking:
        # if out of range,
        if global_position.distance_to(tracking.global_position) >= tracking_distance:
            if (tracking.global_position.x < global_position.x):
                scale.x = -1
            else:
                scale.x = 1


func _on_area_entered(area: Area2D) -> void:
    print("fake kraid entered by area")
    #$CollisionShape2D_up.disabled = true



func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        print("fake kraid entered by body player")
        fall()
    if body.is_in_group("beam"):
        print("fake kraid entered by body beam")
        explode()

func fall():
    if not fallen:
        # todo - play sfx
        # what was the point of this part ??
        $CollisionShape2D_up.set_deferred("disabled", true)
        $CollisionShape2D_up.set_deferred("disabled", false)
        $Sprite2D_up.visible = false
        $Sprite2D_fallen.visible = true
        $CPUParticles2D_FakeKraidSmoke.emission_rect_extents = Vector2(10, 3)
        $CPUParticles2D_FakeKraidSmoke.position.x += 4
        fallen = true
    $sfx_fall.play()

func explode():
    if global_position.distance_to(tracking.global_position) <= 24.0:
        # Only explode if the player is close enough to see!
        print("KRAID-BLAM!")
        $CollisionShape2D_up.set_deferred("disabled", true)
        $CPUParticles2D_FakeKraidSmoke.emitting = true
    $sfx_fall.play()
    
