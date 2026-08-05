extends Node2D

var MainScene = preload("res://main.tscn")

# handle_angles and vars copied from cannon.gd
# Might need to update some things manually!

# Inputs
var up: bool
var left: bool
var down: bool
var right: bool
var diag: bool

## Aiming state
var aimvec: Vector2
var angle: int = 0
var prevangle: int = 0
var flip: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Control/ItemList.grab_focus()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    
    var _ls_hz = Input.get_axis("pad_lstick_left", "pad_lstick_right")
    var _ls_vz = Input.get_axis("pad_lstick_up", "pad_lstick_down")
    
    up = Input.is_action_pressed("pad_up") or (_ls_vz < -.5)
    left = Input.is_action_pressed("pad_left")  or (_ls_hz < -.5)
    down = Input.is_action_pressed("pad_down")  or (_ls_vz > .5)
    right = Input.is_action_pressed("pad_right") or (_ls_hz > .5)
    #diag = Input.is_action_pressed("pad_lb")
    
    handle_angles()
    
    $GPUParticles2D_dpad.emitting = (up or left or down or right)
    $GPUParticles2D_dpad.process_material.direction = (
        Vector3(1.0, 0.0, 0.0).rotated(
            Vector3(0.0, 0.0, 1.0),
            - angle * PI / 4.0
        )
    )
    
    if (
        Input.is_action_just_pressed("pad_x") 
        or Input.is_action_just_pressed("pad_a")
    ):
        $AnimationPlayer.seek(20)
        $title_sfx.play()
    if Input.is_action_pressed("pad_x") and Input.is_action_pressed("pad_a"):
        menu_start()
        
        
    
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pad_b"):
        $GPUParticles2D_padB.emitting =  true
    if event.is_action_released("pad_b"):
        $GPUParticles2D_padB.emitting =  false
    if event.is_action_pressed("pad_a"):
        $GPUParticles2D_padA.emitting =  true
        $GPUParticles2D_padA_start.emitting =  true
    if event.is_action_released("pad_a"):
        $GPUParticles2D_padA.emitting =  false
        $GPUParticles2D_padA_start.emitting =  false
    if event.is_action_pressed("pad_x"):
        $GPUParticles2D_padX.emitting =  true
        $GPUParticles2D_padX_start.emitting =  true
    if event.is_action_released("pad_x"):
        $GPUParticles2D_padX.emitting =  false
        $GPUParticles2D_padX_start.emitting =  false
    if event.is_action_pressed("pad_y"):
        $GPUParticles2D_padY.emitting =  true
    if event.is_action_released("pad_y"):
        $GPUParticles2D_padY.emitting =  false
        
    if event.is_action_pressed("pad_lb") or event.is_action_pressed("pad_lt"):
        $GPUParticles2D_pad_lb.emitting =  true
    if event.is_action_released("pad_lb") or event.is_action_released("pad_lt"):
        $GPUParticles2D_pad_lb.emitting =  false
        
    if event.is_action_pressed("pad_rb") or event.is_action_pressed("pad_rt"):
        $GPUParticles2D_pad_rb.emitting =  true
    if event.is_action_released("pad_rb") or event.is_action_released("pad_rt"):
        $GPUParticles2D_pad_rb.emitting =  false
        
func handle_angles():
    # Eight directions encoded as an int
    # 321
    # 4 0
    # 567
    # Copied from cannnon.gd
    
    prevangle = angle
    if right:
        flip = 1
    if left:
        flip = -1
    
    # Get the vector representing where we're aiming
    aimvec = Vector2(
        int(right) - int(left), #1 - 2*flip,
        int(up) - int(down)
    )
    
    if aimvec.length() == 0:
    #    if abs(aimvec.length()) <= 0.1:
    # what might be the macos problem...
        aimvec.x = flip
    
    # Set the angle according to our X-Y components
    angle = posmod(
        round(4 * aimvec.angle() / PI),
    8)
    
    # If lb is pressed, use this to map (angle, previous_angle) to an angle
    if diag:
        angle = [
            [1, 1, 1, 1, 1, 7, 7, 7][prevangle],  # right
            1, # up right
            [1, 1, 2 -flip, 3, 3, 3, 3, 1][prevangle], #up
            3,
            [5, 3, 3, 3, 3, 5, 5 , 5][prevangle], # left
            5,
            [7, 7, 5, 5, 5, 5, 6 + flip, 7 ][prevangle], # down
            7
        ][angle]

func _on_item_list_item_activated(index: int) -> void:
    [
        menu_start,
        menu_options,
        menu_quit
    ][index].call()

func menu_start():
    var main_scene = MainScene.instantiate()
    #var b = BeamShot.instantiate()
    #b.ice = owner.has_ice_beam
    get_tree().change_scene_to_node(main_scene)

func menu_options():
    print("TODO OPTIONS")

func menu_quit():
    get_tree().quit()
    print("SEE YOU NEXT MISSION")
