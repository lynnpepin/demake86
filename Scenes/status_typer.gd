#extends Node2D
extends CanvasLayer

var target_text;
var time_per_char: float = 0.0625
var prevtimer: float = 0.0
var timer: float = 0.0
var disappear_after_time = 8.0
var texts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texts = [$StatusTyper, $Shadow]
	start("", 1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Play noise when each character added
	var char_idx_to_draw_to = round(timer / time_per_char)
	var total_chars = len(target_text)
	if timer < disappear_after_time:
		if char_idx_to_draw_to < total_chars:
			if target_text[char_idx_to_draw_to] != " ":
				if round(prevtimer / time_per_char) != round(timer/time_per_char):
					$SfxrStreamPlayer2D.play()
	prevtimer = timer
	
	timer += delta
	# Set the text to target_text[0, ii]
	# where ii = index of character we're set to
	for text in texts:
		text.text = target_text.substr(
			0,
			clamp(char_idx_to_draw_to, 0, total_chars)	
		)
		if timer >= disappear_after_time:
			timer = disappear_after_time
			text.text = ""

func start(
	text_to_target: String,
	time_per_char: float = 0.25,
	disappear_after_time: float = 10
):
	for text in texts:
		text.text = ""
	target_text = text_to_target
	timer = 0
	
