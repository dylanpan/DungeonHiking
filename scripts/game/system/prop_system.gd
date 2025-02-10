class_name Prop_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

func update(delta):
	if World_Helper.game_state_flag == base.game_state.USE_PROP:
		World_Helper.game_state_flag = base.game_state.FIGHT
