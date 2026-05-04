extends Camera2D

# Model camera shake as a spring;
# A = -k*a -d*v
# But apply up to three at a time

var AAs: Array[Vector2] = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]

# Velocity array for multiple concurrent spring o
var VVs: Array[Vector2] = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]

# Hooke's constant; higher = tighter, more dramatic shake
var KKs: Array[float]   = [24.0, 24.0, 24.0]

# Damping constant; higher = quicker return to 0
var DDs: Array[float]   = [12.0, 12.0, 12.0]

var shaking_timer = 0.0
var shaking_timer_max = 12.0

func _process(delta):
    if shaking_timer >= shaking_timer_max:
        # Prevent shaking from going on too long
        shaking_timer = 0.0
        position = Vector2(0,0)
        shaking_timer = 0.0
        for ii in [0, 1, 2]:
            AAs[ii] = Vector2(0,0)
            VVs[ii] = Vector2(0,0)
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
    position.y = strength
    AAs[0].y = strength
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
    # Simple set shake: Set two concurrent oscillators
    position = strength
    AAs[0] = strength
    VVs[0] = Vector2(0,0)
    KKs[0] = KK[0]
    DDs[0] = DD[0]
    AAs[1] = Vector2(0,0)
    VVs[1] = -strength.rotated(PI)/2.0
    KKs[1] = KK[1]
    DDs[1] = DD[1]
    
