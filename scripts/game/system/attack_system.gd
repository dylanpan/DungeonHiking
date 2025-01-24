class_name Attack_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

func update(delta):
	if World_Helper.game_state_flag == base.game_state.START:
		var attack_index_list = World_Helper.get_attack_index_list()
		# 攻击敌方单位
