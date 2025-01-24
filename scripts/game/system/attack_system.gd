class_name Attack_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

func get_damage(index, be_atk_index):
	var atk_list = World_Helper.get_component_property_list("atk", "atk")
	var def_list = World_Helper.get_component_property_list("def", "def")
	var mana_list = World_Helper.get_component_property_list("mana", "mana")
	var critical_atk_list = World_Helper.get_component_property_list("critical", "critical_atk")
	var earth_element_atk_list = World_Helper.get_component_property_list("earth_element", "earth_element_atk")
	var earth_element_def_list = World_Helper.get_component_property_list("earth_element", "earth_element_def")
	var fire_element_atk_list = World_Helper.get_component_property_list("fire_element", "fire_element_atk")
	var fire_element_def_list = World_Helper.get_component_property_list("fire_element", "fire_element_def")
	var thunder_element_atk_list = World_Helper.get_component_property_list("thunder_element", "thunder_element_atk")
	var thunder_element_def_list = World_Helper.get_component_property_list("thunder_element", "thunder_element_def")
	var wind_element_atk_list = World_Helper.get_component_property_list("wind_element", "wind_element_atk")
	var wind_element_def_list = World_Helper.get_component_property_list("wind_element", "wind_element_def")
	# 攻击方参数
	var atk = atk_list[index]
	var mana = mana_list[index]
	var critical_atk = critical_atk_list[index]
	var earth_element_atk = earth_element_atk_list[index]
	var fire_element_atk = fire_element_atk_list[index]
	var thunder_element_atk = thunder_element_atk_list[index]
	var wind_element_atk = wind_element_atk_list[index]
	# 被攻击方参数
	var def = def_list[be_atk_index]
	var earth_element_def = earth_element_def_list[be_atk_index]
	var fire_element_def = fire_element_def_list[be_atk_index]
	var thunder_element_def = thunder_element_def_list[be_atk_index]
	var wind_element_def = wind_element_def_list[be_atk_index]
	# 结算: 
	# 物理攻击 = 暴击 ? (普通攻击 + 暴击攻击) * 暴击倍数 : 普通攻击
	var is_critical = get_is_critical(index)
	var critical_radio = 2
	var p_atk = atk
	if is_critical:
		p_atk = (atk + critical_atk) * critical_radio
	# 属性攻击 = 属性攻击
	#var e_atk
	# 物理伤害 = 物理攻击 - 物理防御
	var p_damage = p_atk * (1 - def * 0.01)
	# 属性伤害 = 属性攻击 - 属性防御
	var e_damage = earth_element_atk * (1 - earth_element_def * 0.01) \
					 + fire_element_atk * (1 - fire_element_def * 0.01) \
					 + thunder_element_atk * (1 - thunder_element_def * 0.01) \
					 + wind_element_atk * (1 - wind_element_def * 0.01)
	# 伤害 = 物理伤害 + 属性伤害
	var damage = p_damage + e_damage
	return damage

func update_hp_and_shield(index, damage):
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var shield_list = World_Helper.get_component_property_list("shield", "shield")
	var shield = shield_list[index]
	if shield > damage:
		shield_list[index] -= damage
		Log_Helper.log(["----->>", index, ", shield: ", shield_list[index], ", hp: ", hp_list[index]])
		
		if World_Helper.game_state_flag == base.game_state.FIGHT:
			World_Helper.game_state_flag = base.game_state.MOVE
	else:
		if hp_list[index] > 0:
			hp_list[index] -= damage - shield
			shield_list[index] = 0
			Log_Helper.log(["----->>>>", index, ", shield: ", shield_list[index], ", hp: ", hp_list[index]])
			if hp_list[index] < 0:
				hp_list[index] = 0
				World_Helper.game_state_flag = base.game_state.END
				# TODO 出现掉落
			else:
				if World_Helper.game_state_flag == base.game_state.FIGHT:
					World_Helper.game_state_flag = base.game_state.MOVE
	#var _tmp = World_Helper.get_world_component_property_map()
	#World_Helper.print_dict_properties(_tmp)

func get_is_critical(index):
	var critical_rate_list = World_Helper.get_component_property_list("critical", "critical_rate")
	var critical_rate = critical_rate_list[index]
	# TODO 随机几率
	return false

func get_is_counter(be_atk_index):
	var counter_rate_list = World_Helper.get_component_property_list("counter", "counter_rate")
	var counter_rate = counter_rate_list[be_atk_index]
	# TODO 随机几率
	return false

func get_is_dodge(be_atk_index):
	var dodge_list = World_Helper.get_component_property_list("dodge", "dodge")
	var dodge = dodge_list[be_atk_index]
	# TODO 随机几率
	return false

func update(delta):
	if World_Helper.game_state_flag == base.game_state.FIGHT:
		var attack_index_list = World_Helper.get_attack_index_list()
		
		var id_type_list = World_Helper.get_component_property_list("id", "id_type")
		var atk_distance_list = World_Helper.get_component_property_list("atk", "atk_distance")
		var hp_list = World_Helper.get_component_property_list("hp", "hp")
		
		var length = id_type_list.size()
		# 攻击敌方单位
		for index in attack_index_list:
			# 选择攻击方式（默认物理攻击，技能、道具为主动使用）
			# 根据攻击距离选择被攻击单位
			var atk_distance = atk_distance_list[index]
			# 判断攻击方类型
			var atk_radio = 1
			if id_type_list[index] == base.type.PEOPLE:
				atk_radio = 1
			elif id_type_list[index] == base.type.MONSTER:
				atk_radio = -1
			if hp_list[index] > 0:
				Log_Helper.log(["---------------", index, ", atk_radio: ", atk_radio])
				# [0,1,2,3,4]
				for atk_range_index in range(atk_distance):
					var be_atk_index = index + atk_radio * (atk_range_index + 1)
					if be_atk_index < length and be_atk_index >= 0 and hp_list[be_atk_index] > 0:
						# 本次攻击伤害
						var damage = get_damage(index, be_atk_index)
						Log_Helper.log(["----->>", index ," vs ", be_atk_index, ", damage: ", damage])
						# 反击即伤害的同时对对方造成无闪避无反击的伤害
						var counter_damage = 0
						var is_counter = get_is_counter(be_atk_index)
						if is_counter:
							# 反击伤害 = 无闪避无反击的伤害
							counter_damage = get_damage(be_atk_index, index)
						Log_Helper.log(["----->>", be_atk_index, ", counter_damage: ", counter_damage])
						# 扣减敌方血量 = 伤害 - 护盾
						if damage > 0:
							# 伤害 = 闪避 ? 0 : 伤害
							var is_dodge = get_is_dodge(be_atk_index)
							if is_dodge:
								damage = 0
								Log_Helper.log(["----->>", be_atk_index, " dodge !!!"])
							else:
								update_hp_and_shield(be_atk_index, damage)
						# 扣减我方血量 = 伤害 - 护盾
						if counter_damage > 0:
							update_hp_and_shield(index, counter_damage)
				# 更新对应数据
