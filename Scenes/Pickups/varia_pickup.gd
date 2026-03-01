extends PickupClass

func player_do(body):
    body.has_varia_suit = true
    body.regain_barrier()
