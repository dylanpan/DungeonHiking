class_name Prop_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

func update(delta):
	if World_Helper.game_state_flag == base.game_state.USE_PROP:
		# TEST data: sim use prop
		World_Helper.set_prop_index_by_key(1, 1)
		World_Helper.game_state_flag = base.game_state.FIGHT
