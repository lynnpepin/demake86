extends Node2D

# note: 12 char max, 5 line max

@export var disappear_after_time: float = 10.0
@export var time_per_char: float = 1.0/24.0

var credit_slides = [
"""IN DEFEATING
THE BARONESS
YOU HAVE
FULFILLED
YOUR MISSION
AND
YOUR DESTINY.
""",
"""BUT

THE SETONA
ARE AWAKE.

THE GALAXY
IS IN PERIL.
""",
"""

  PRAY FOR
  A TRUE PEACE
  IN SPACE!

""",

"""CREDITS
""",

""" A GAME BY

  OPOSSUM
  CARRION

IN HOMAGE TO
METROID 1986
""",

""" MADE WITH

 G O D O T

    AND
    
 ABSOLUTELY
  ZERO AI
""",

"""LEGALLY
DISTINCT
ORIGINAL
CHARACTERS,
NOT
AFFILIATED
WITH
NINTENDO
""",
"""WITH TOOLS:
GIMP, LINUX,
PIXAKI, JFXR,
BLENDER,
STRUDEL.CC,
AND MORE
""",
"""RESOURCES:
BLENDKIT
 (SKULL)
ANDROIDARTS
 (FAMICUBE
  PALETTE)
RONALDREAGAN
 (SPEECH)
""",
"""COVERS OF
MUSIC FROM
METROID 1986.

CREDITS TO
OG COMPOSER:
Hirokazu
"Hip" Tanaka
""",

"""
SPECIAL THANKS:
RAE WHITELEY:
 ENDING ART
""",

"""THANK YOU
TO BELOVED
PLAYTESTERS:

RUBY
RAE WHITELEY
JAE GAERY

""",

"""PLAYTESTER 1
PLAYTESTER 2
PLAYTESTER 3
PLAYTESTER 4
PLAYTESTER 5
PLAYTESTER 6
PLAYTESTER 7

""",

"""AND A
SPECIAL
THANKS TO

    YOU!!

FOR PLAYING
THE . . .
""",

"""LEGALLY-
  DISTINCT
ACTION-
  ADVENTURE
PLATFORMING-
  GAME
SET  ON  A
-METEOROID-
""",
"""
   A.K.A.

---------------
- DEMAKE86 -
---------------

""",
"""    SEE
    YOU
    NEXT
    MISSION
"""
]

@onready var credits_ii: int = 0

func _ready() -> void:
    $Typer.time_per_char = time_per_char
    $Typer.disappear_after_time = disappear_after_time
    $Typer.start("""MISSION
ACCOMPLISHED
""", .25, 7)
    $Timer.start(2.0)


# After credits: Last slide
func _on_timer_timeout() -> void:
    print("TIMER TIMEOUT")
    var num_slides = len(credit_slides)
    if credits_ii < num_slides:
        $Typer.target_text = credit_slides[credits_ii]
        $Typer.start(credit_slides[credits_ii],
          .1, 9.0
        )
        $Timer.start(7.20)
    elif credits_ii == num_slides:
        $Typer.start("""MISSION TIME:
%s
SECONDS

DEATHS:
%s

""" %  [str(snapped(Global.game_timer, 0.1)), str(Global.deaths)]
)
    # After the last slide
    elif credits_ii == num_slides + 1:
        start_ending_art()
        $Typer.start("""






THE END
        """, 1.0, 40 * 365.25 * 24 * 60 * 60)

 #   else:
 #       $CPUParticles2D.modulate -= Color(0, 0, 0, .125)
    credits_ii += 1


func start_ending_art():
    $AnimationPlayer.play("ending_art")

func ending_fade_into_art():
    $Line2D_Spawns_Asteroids.queue_free()
    $gunship.queue_free()
    $CPUParticles2D.emitting = false
    # make the right one visible
    if Global.game_timer <= 86.0:
        $EndingSprites/CreditArt086.visible = true
    elif Global.game_timer <= 186.0:
        $EndingSprites/CreditArt386.visible = true
    elif Global.game_timer <= 286.0:
        $EndingSprites/CreditArt286.visible = true
    elif Global.game_timer <= 386.0:
        $EndingSprites/CreditArt386.visible = true
    else:
        $EndingSprites/CreditArt486.visible = true

#JAE GEARY,
#VEEV METROID
#(THAT IS HER
#LEGAL NAME),
#(REALLY!!),
