extends Node2D

# note: 12 char max, 5 line max

var credit_slides = [
""" A GAME BY

  OPOSSUM
  CARRION

""",
""" MADE WITH

 G O D O T

    AND
    
 ABSOLUTELY
  ZERO  AI
""",


"""
AND TOOLS:
 GIMP, JFXR,
 PIXAKI,
 BLENDER,
 AUDACITY,
 LINUX
""",


"""AND NOT
AFFILIATED
WITH
NINTENDO.
""",

"""THANK YOU
TO MY
BELOVED
PLAYTESTERS
WHO HELPED
MAKE THIS
NOT SUCK:
""",

"""JAE GEARY,
VEEV METROID
(THAT IS HER
LEGAL NAME),
(REALLY!!),
PLAYTESTER 3
PLAYTESTER 4
PLAYTESTER 5
""",


"""AND A
SPECIAL
THANKS TO...

    YOU !!!

FOR PLAYING
   THE ...
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
"""
    SEE
    
    YOU
    
    NEXT
    
    MISSION
""",

"""
FOURTY YEARS

1986-AUG-6

2026-AUG-6
""",
"""
P.S.

TRANS RIGHTS 
 ARE
HUMAN RIGHTS
"""
]

# playtesters, used jfxr, gimp, blender; made with godot, nintendo, thank you

@onready var credits_ii: int = 0

func _ready() -> void:
    $Typer.time_per_char = 0.0625
    $Typer.disappear_after_time = 12.0
    $Typer.start("CREDITS", .25, 7)
    $Timer.start(2.0)


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
    elif credits_ii == num_slides + 1:
        $Typer.start("""

 DEMAKE 86
        """, 1.0, 40 * 365.25 * 24 * 60 * 60)

    else:
        $CPUParticles2D.modulate -= Color(0, 0, 0, .125)
    credits_ii += 1
