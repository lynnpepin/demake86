extends ParallaxBackground

@export var visible_on_start: bool = true

func _ready() -> void:
    visible = visible_on_start
