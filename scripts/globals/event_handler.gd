extends Node

signal game_loaded()
signal pick_pocket_started(npc_inventory, player_inventory)
signal pick_pocket_ended(npc_inventory, player_inventory)

signal pocketing_started()
signal pocketing_canceled()
signal pocketing_ended()

signal display_dialogue(dialogue)
