extends Node

signal game_loaded()
signal player_died()
signal update_player_hp(health)
signal pick_pocket_started(npc_inventory, player_inventory)
signal pick_pocket_ended(npc_inventory, player_inventory)
signal update_sprint(sprint_time)

signal pocketing_started()
signal pocketing_canceled()
signal pocketing_ended()

signal alert_guards()

signal start_canvas_shake(trauma)
signal start_camera_shake(trauma)

signal load_dialogue(dialogue, _name)
signal show_dialogue()
signal dialogue_finished()
