extends EnemyClass

var direction: int = 1

@export var start_hp := 2  # new default
@export var zoomer_speed := 12

var angle = PI; # make sure this is 
@export var start_angle = 180;
var rotate_timer = 0.25;

func _ready():
    health = start_hp
    speed = zoomer_speed
    angle = start_angle * PI / 180;
    super()

func spin_cw():
    rotate(PI/2.0)
    angle = fmod(angle + PI / 2.0, PI * 2.0)

func spin_ccw():
    rotate(-PI/2.0)
    angle = fmod(angle - PI / 2.0, PI * 2.0)
    
    
func _physics_process(delta: float) -> void:

    if freeze_timer <= 0 and health >= 0:
        var f_col = $RayCast2D_forward.get_collider()
        var g_col = $RayCast2D_ground.get_collider()
        var l_col = $RayCast2D_left.get_collider()
        var r_col = $RayCast2D_right.get_collider()
        
        if r_col == null and g_col == null and l_col != null:
            # rotate!
            spin_cw()
        # TODO - more cases: Inner angle, ramp outer angle, ramp inner angle, U-bend inner angle
        # TODO - g_col <= .25px any time
        
        var collision = move_and_collide(delta * Vector2(speed , 0).rotated(angle))
    

func _old_physics_process(delta: float) -> void:
    rotate_timer = clamp(rotate_timer - delta, 0.0, 1.0)
    var ground_coll = $RayCast2D_ground.get_collider()
    
    if freeze_timer <= 0 and health >= 0:
        if ground_coll == null:# and rotate_timer <= 0:
            var left_coll = $RayCast2D_left.get_collider()
            var right_coll = $RayCast2D_right.get_collider()
            
            # if neither or both, move downward until collision; todo
            if left_coll == null and right_coll != null:
                rotate(-PI / 2.0)
                #print("... Zoomer should rotate CCW!")
                angle = fmod(angle - PI / 2.0, PI * 2.0)
                #print("Zoomer rotated; angle=", angle/PI)
                rotate_timer = 0.5
            elif left_coll != null and right_coll == null:
                rotate(PI / 2.0)
                #print("... Zoomer should rotate CW!")
                angle = fmod(angle + PI / 2.0, PI * 2.0)
                #print("Zoomer rotated; angle=", angle/PI)
                rotate_timer = 0.5
            else:
                # todo; 'fall' downward and dont rotate
                pass
            
        #var collision = move_and_collide(delta * Vector2(-speed , 0))
        var collision = move_and_collide(delta * Vector2(speed , 0).rotated(angle))
        #if collision:
        #	direction *= -1
    
    
        
