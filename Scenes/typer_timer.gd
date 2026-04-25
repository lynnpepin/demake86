#extends Node2D
extends CanvasLayer

var target_text = "";
var texts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    texts = [$Typer, $Shadow]
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    # where ii = index of character we're set to
    for text in texts:
        text.text = target_text
