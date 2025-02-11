class_name Calculate_System
extends I_System

func init():
	pass

func destroy():
	pass

# 检查战斗是否结束
func _check_battle_end() -> bool:
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var id_type_list = World_Helper.get_component_property_list("id", "id_type")
	
	var people_alive = false
	var monster_alive = false
	
	# 检查双方是否都还有存活单位
	for index in range(id_type_list.size()):
		if hp_list[index] > 0:
			if id_type_list[index] == base.type.PEOPLE:
				people_alive = true
			elif id_type_list[index] == base.type.MONSTER:
				monster_alive = true
				
		# 如果双方都有存活单位，可以提前返回
		if people_alive and monster_alive:
			return false
			
	# 只要有一方全部阵亡就结束战斗
	return true

func update(delta):
	if World_Helper.game_state_flag == base.game_state.CALCULATE:
		Log_Helper.log(["[calculate] system run ----->> "])
		
		# 检查战斗是否结束
		if _check_battle_end():
			Log_Helper.log(["[calculate] battle end, one side is defeated"])
			World_Helper.game_state_flag = base.game_state.END
		else:
			Log_Helper.log(["[calculate] battle continues"])
			World_Helper.game_state_flag = base.game_state.MOVE
