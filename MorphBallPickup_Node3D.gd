extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PivotLight1.rotate_y(delta)
	#$OmniLight3D.rotate_object_local(Vector3a(0,0,1), delta)
	#$OmniLight3D.rotate(Vector3(0,0,1),delta*60)
