extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Declare member variables here. Examples:
var binary_actions = [
	"pad_a", "pad_b", "pad_x", "pad_y",
	"pad_left", "pad_right", "pad_up", "pad_down",
	"pad_lb", "pad_rb",
	"pad_ltb", "pad_rtb",
	"pad_ls", "pad_rs",
	"mb1", "mb2", "mb3",
	"mw_up", "mw_down", "mw_left", "mw_right",
	"mw_x1", "mw_x2",
	"pad_select", "pad_start"
]

var axis_actions = [
	"pad_lstick_left", "pad_lstick_right",
	"pad_lstick_up", "pad_lstick_down",
	"pad_rstick_left", "pad_rstick_right", "pad_rstick_up", "pad_rstick_down",
	"pad_lt", "pad_rt"
]

func _process(delta):
	# This function is called every frame.
#	for action in binary_actions:
#		if Input.is_action_just_pressed(action):
#			print(action + " pressed.")
#		if Input.is_action_just_released(action):
#			print(action + " released.")
#
#	if (Input.is_action_just_pressed("pad_lb") and Input.is_action_pressed("pad_rb")) or (Input.is_action_just_pressed("pad_rb") and Input.is_action_pressed("pad_lb")):
#		for action in axis_actions:
#			if Input.get_action_strength(action) > 0:
#				print(action + ": " + str(Input.get_action_strength(action)))
	pass
			


func _enter_tree():
	# When the node enters the Scene Tree, it becomes active
	# and  this function is called. Children nodes have not entered
	# the active scene yet. In general, it's better to use _ready()
	# for most cases.
	pass

func _exit_tree():
	# When the node exits the Scene Tree, this function is called.
	# Children nodes have all exited the Scene Tree at this point
	# and all became inactive.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# This is called every physics frame.
	pass

# see https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html for explanation
# see https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html for good snippets
# see https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html for clicks
func _input(ev):
	# generic input first
	pass

func _input_event(ev):
	# Then GUI input
	pass

func _unhandled_input(ev):
	# and last, input nobody else 'consumed'
	pass
	
