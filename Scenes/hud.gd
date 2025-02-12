extends CanvasLayer


var ecount_sprite = load("res://art/counters/energy.png")
var mcount_sprite = load("res://art/counters/missile.png")
var ecounter_sprites = []
var mcounter_sprites = []
var MAX_ENERGY = 24
var MAX_MISSILES = 24

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in MAX_ENERGY:
		var eicon = Sprite2D.new()
		eicon.texture = ecount_sprite
		var dx = (i % 6)
		var dy = floor(i / 6)
		eicon.position = Vector2(
			2.5 + dx * 3,
			2.5 + dy * 2
		)
		eicon.visible = false
		add_child(eicon)
		ecounter_sprites.append(eicon)
		
	for i in MAX_MISSILES:
		var micon = Sprite2D.new()
		micon.texture = mcount_sprite
		var dx = (i % 4)
		var dy = floor(i / 4)
		micon.position = Vector2(
			61.5 - dx * 2 - int((dy % 2) == 1),
			3 + dy*2
		)
		micon.visible = false
		add_child(micon)
		mcounter_sprites.append(micon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
