extends TileMapLayer

@export var enable_on_start: bool = false

func _ready() -> void:
    enabled = enable_on_start
