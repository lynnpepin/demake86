extends PickupClass

func player_do(body):
    body.has_varia_suit = true
    body.regain_barrier()
    body.barrier_timer = body.BARRIER_RECHARGE_PERIOD
    # This is not the way to do this!! Should be func in relan. Quick n dirty works tho
