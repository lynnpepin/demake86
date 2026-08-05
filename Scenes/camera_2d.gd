extends Camera2D

# Model camera shake as a spring;
# A = -k*a -d*v
# But apply up to three at a time

@export var SHAKABLE: bool = false

var AAs: Array[Vector2] = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]

# Velocity array for multiple concurrent spring o
var VVs: Array[Vector2] = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]

# Hooke's constant; higher = tighter, more dramatic shake
var KKs: Array[float]   = [24.0, 24.0, 24.0]

# Damping constant; higher = quicker return to 0
var DDs: Array[float]   = [12.0, 12.0, 12.0]

var shaking_timer = 0.0
var shaking_timer_max = 12.0

@export var screenshot_interval: float = 1.0
var screenshot_index: int = 0

# quick hack; shaking is less juicy after moving to 60 physics fps
# so i need to make it shake more
@export var SHAKE_MORE: float = 4.0

func _ready():
    if screenshot_interval > 0:
        if $ScreenshotTimer:
            $ScreenshotTimer.start(screenshot_interval)

func _physics_process(delta):
    if SHAKABLE:
        if shaking_timer >= shaking_timer_max:
            reset_shake()
            shaking_timer = 0.0
        else:
            var all_zero: bool = true
            for ii in [0, 1, 2]:
                # First, prevent unactivated oscillator from being activated
                if (   VVs[ii].length() + AAs[ii].length() + position.length() < 1.0):
                        AAs[ii] = Vector2(0,0)
                        VVs[ii] = Vector2(0,0)
                else:
                    all_zero = false
                    AAs[ii] = -KKs[ii] * position - VVs[ii]*DDs[ii]
                    VVs[ii] += AAs[ii] * delta
                    position += VVs[ii]
            
            if all_zero:
                # all the vectors reduced to zero, we can reset position
                position = Vector2(0,0)
                shaking_timer = 0.0
            else:
                shaking_timer += delta


func vshake(strength: float, KK=8.0, DD=16.0):
    if SHAKABLE:
        position.y = strength * SHAKE_MORE
        AAs[0].y = strength * SHAKE_MORE
        VVs[0] = Vector2(0,0)
        KKs[0] = KK
        DDs[0] = DD
        VVs[1] = Vector2(0,0)
        KKs[1] = 2.0
        DDs[1] = 64.0
        VVs[2] = Vector2(0,0)
        KKs[2] = 2.0
        DDs[2] = 64.0
    

func set_shake(
    strength: Vector2,
    KK = [8.0, 2.0],
    DD = [16.0, 8.0]
) -> void:
    if SHAKABLE:
        # Simple set shake: Set two concurrent oscillators
        position = strength * SHAKE_MORE
        AAs[0] = strength * SHAKE_MORE
        VVs[0] = Vector2(0,0)
        KKs[0] = KK[0]
        DDs[0] = DD[0]
        AAs[1] = Vector2(0,0)
        VVs[1] = -strength.rotated(PI) * SHAKE_MORE     /2.0
        KKs[1] = KK[1]
        DDs[1] = DD[1]
        
func reset_shake():
    # Prevent shaking from going on too long
    position = Vector2(0,0)
    shaking_timer = 0.0
    for ii in [0, 1, 2]:
        AAs[ii] = Vector2(0,0)
        VVs[ii] = Vector2(0,0)


func take_screenshot(scrshit_idx = 0):
    if screenshot_interval > 0:
        var screenshot = get_viewport().get_texture().get_image()
        screenshot.save_png("./screenshots/screenshot_%04d.png" % scrshit_idx)
        print("Saving screenshot!")
        if $ScreenshotTimer:
            $ScreenshotTimer.start(screenshot_interval)
        screenshot_index += 1
    


func _on_screenshot_timer_timeout() -> void:
    take_screenshot(screenshot_index)
