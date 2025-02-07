class_name Attack_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

func get_damage(index, be_atk_index, skill_index):
	var atk_list = World_Helper.get_component_property_list("atk", "atk")
	var skill_ids_list = World_Helper.get_component_property_list("skill", "skill_ids")
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
	var skill_ids = skill_ids_list[index]
	# 被攻击方参数
	var def = def_list[be_atk_index]
	var earth_element_def = earth_element_def_list[be_atk_index]
	var fire_element_def = fire_element_def_list[be_atk_index]
	var thunder_element_def = thunder_element_def_list[be_atk_index]
	var wind_element_def = wind_element_def_list[be_atk_index]
	# 结算: 
	var damage = 0
	if skill_index >= 0:
		var skill_id = skill_ids[skill_index]
		var skill_meta = Meta_Helper.get_skill(skill_id)
		# 技能攻击 = 配置表中的技能攻击
		var s_atk = skill_meta["atk"]
		var s_def = def
		# 技能伤害 = 技能攻击 - 技能防御
		var s_def_max = 1000.0
		var s_damage = s_atk * (1 - s_def / s_def_max)
		# 属性攻击 = 配置表中的属性攻击 + 本身的属性攻击
		var s_earth_element_atk = earth_element_atk + skill_meta["earth_element_atk"]
		var s_fire_element_atk = fire_element_atk + skill_meta["fire_element_atk"]
		var s_thunder_element_atk = thunder_element_atk + skill_meta["thunder_element_atk"]
		var s_wind_element_atk = wind_element_atk + skill_meta["wind_element_atk"]
		# 属性伤害 = 属性攻击 - 属性防御
		var element_def_max = 1000.0
		var e_damage = s_earth_element_atk * (1 - earth_element_def / element_def_max) \
						 + s_fire_element_atk * (1 - fire_element_def / element_def_max) \
						 + s_thunder_element_atk * (1 - thunder_element_def / element_def_max) \
						 + s_wind_element_atk * (1 - wind_element_def / element_def_max)
		# 伤害 = 物理伤害 + 属性伤害
		damage = s_damage + e_damage
	else:
		# 物理攻击 = 暴击 ? (普通攻击 + 暴击攻击) * 暴击倍数 : 普通攻击
		var is_critical = get_is_critical(index)
		var critical_radio = 2
		var p_atk = atk
		if is_critical:
			p_atk = (atk + critical_atk) * critical_radio
		# 属性攻击 = 属性攻击
		#var e_atk
		# 物理伤害 = 物理攻击 - 物理防御
		var def_max = 1000.0
		var p_damage = p_atk * (1 - def / def_max)
		# 属性伤害 = 属性攻击 - 属性防御
		var element_def_max = 1000.0
		var e_damage = earth_element_atk * (1 - earth_element_def / element_def_max) \
						 + fire_element_atk * (1 - fire_element_def / element_def_max) \
						 + thunder_element_atk * (1 - thunder_element_def / element_def_max) \
						 + wind_element_atk * (1 - wind_element_def / element_def_max)
		# 伤害 = 物理伤害 + 属性伤害
		damage = p_damage + e_damage
	return damage

func update_hp_and_shield(index, damage):
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var shield_list = World_Helper.get_component_property_list("shield", "shield")
	var shield = shield_list[index]
	if shield > damage:
		shield_list[index] -= damage
		Log_Helper.log(["[attack] ----->>>> result: ", index, ", shield: ", shield_list[index], ", hp: ", hp_list[index]])
		
		if World_Helper.game_state_flag == base.game_state.FIGHT:
			World_Helper.game_state_flag = base.game_state.MOVE
	else:
		if hp_list[index] > 0:
			hp_list[index] -= damage - shield
			shield_list[index] = 0
			Log_Helper.log(["[attack] ----->>>> result: ", index, ", shield: ", shield_list[index], ", hp: ", hp_list[index]])
			if hp_list[index] < 0:
				hp_list[index] = 0
				# TODO 出现掉落
				
				if is_none_atk(index):
					World_Helper.game_state_flag = base.game_state.END
				else:
					if World_Helper.game_state_flag == base.game_state.FIGHT:
						World_Helper.game_state_flag = base.game_state.MOVE
			else:
				if World_Helper.game_state_flag == base.game_state.FIGHT:
					World_Helper.game_state_flag = base.game_state.MOVE
			Log_Helper.log(["[attack] ----->>>> end hp: ", hp_list])
	#var _tmp = World_Helper.get_world_component_property_map()
	#World_Helper.print_dict_properties(_tmp)

func is_none_atk(be_atk_index):
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var id_type_list = World_Helper.get_component_property_list("id", "id_type")
	var be_atk_type = id_type_list[be_atk_index]
	var be_attack_index_list = []
	var i_length = id_type_list.size()
	for index in range(i_length):
		# 判断攻击方类型
		if id_type_list[index] == be_atk_type and hp_list[index] > 0:
			be_attack_index_list.append(index)
	var b_length = be_attack_index_list.size()
	return b_length <= 0

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

func get_be_attack_index_list(atk_index, atk_type, skill_index):
	# all [0,1,2,3,4]
	# atk    [0]
	# be_atk [1,2,3,4]
	# atk    [0] - 2
	# be_atk [1,2]
	# 根据攻击距离选择被攻击单位
	var id_type_list = World_Helper.get_component_property_list("id", "id_type")
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var atk_distance_list = World_Helper.get_component_property_list("atk", "atk_distance")
	var atk_count_list = World_Helper.get_component_property_list("atk", "atk_count")
	# 一方全部单位列表
	var be_attack_index_list = []
	var i_length = id_type_list.size()
	var atk_id_type = id_type_list[atk_index]
	for index in range(i_length):
		# 判断攻击方类型
		if id_type_list[index] != atk_id_type:
			be_attack_index_list.append(index)
	
	var atk_distance = atk_distance_list[atk_index]
	var atk_count = atk_count_list[atk_index]
	if atk_type == base.atk_type.SKILL:
		# TODO 实现 4 回合 10 点火属性伤害，晕眩 2 回合
		var skill_ids_list = World_Helper.get_component_property_list("skill", "skill_ids")
		var skill_ids = skill_ids_list[atk_index]
		var skill_id = skill_ids[skill_index]
		var skill_meta = Meta_Helper.get_skill(skill_id)
		atk_distance = skill_meta["atk_distance"]
		atk_count = skill_meta["atk_count"]
	var can_be_atk_index_list = []
	var length = be_attack_index_list.size()
	for atk_range_index in range(atk_distance):
		# 根据攻击距离获得对应范围的单位
		if atk_range_index < length and hp_list[be_attack_index_list[atk_range_index]] > 0:
			can_be_atk_index_list.append(be_attack_index_list[atk_range_index])
	# 获取对应攻击个数的单位列表进行返回
	var c_length = can_be_atk_index_list.size()
	var be_atk_index_list = []
	var be_atk_index = -1
	for count in range(atk_count):
		if c_length > 0:
			be_atk_index = can_be_atk_index_list[c_length - 1 - count]
			if hp_list[be_atk_index] <= 0:
				for index in can_be_atk_index_list:
					if hp_list[index] > 0:
						be_atk_index = index
			be_atk_index_list.append(be_atk_index)
	return be_atk_index_list

func _do_attack(index):
	var is_do = false
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var length = hp_list.size()
	# 本次攻击伤害
	if hp_list[index] > 0:
		var be_atk_index_list = get_be_attack_index_list(index, base.atk_type.NORMAL, -1)
		for be_atk_index in be_atk_index_list:
			if be_atk_index < length and be_atk_index >= 0 and hp_list[be_atk_index] > 0:
				is_do = true
				var damage = get_damage(index, be_atk_index, -1)
				Log_Helper.log(["[attack] ----->> ", index ," vs ", be_atk_index, ", damage: ", damage])
				# 反击即伤害的同时对对方造成无闪避无反击的伤害
				var counter_damage = 0
				var is_counter = get_is_counter(be_atk_index)
				if is_counter:
					# 反击伤害 = 无闪避无反击的伤害
					counter_damage = get_damage(be_atk_index, index, -1)
					Log_Helper.log(["[attack] ----->> ", be_atk_index, ", counter_damage: ", counter_damage])
				# 扣减敌方血量 = 伤害 - 护盾
				if damage > 0:
					# 伤害 = 闪避 ? 0 : 伤害
					var is_dodge = get_is_dodge(be_atk_index)
					if is_dodge:
						damage = 0
						Log_Helper.log(["[attack] ----->> ", be_atk_index, " dodge !!!"])
					else:
						update_hp_and_shield(be_atk_index, damage)
				# 扣减我方血量 = 伤害 - 护盾
				if counter_damage > 0:
					update_hp_and_shield(index, counter_damage)
	return is_do

func _do_prop_attack(index):
	var is_do = false
	return is_do

func _do_skill_attack(index):
	var is_do = false
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var length = hp_list.size()
	# 本次技能伤害
	if hp_list[index] > 0:
		var skill_index = 0
		var be_atk_index_list = get_be_attack_index_list(index, base.atk_type.SKILL, skill_index)
		for be_atk_index in be_atk_index_list:
			if be_atk_index < length and be_atk_index >= 0 and hp_list[be_atk_index] > 0:
				is_do = true
				# TODO 获取使用技能索引
				var damage = get_damage(index, be_atk_index, skill_index)
				Log_Helper.log(["[attack] ----->> ", index ," vs ", be_atk_index, ", damage: ", damage])
				if damage > 0:
					update_hp_and_shield(be_atk_index, damage)
	return is_do

func _get_atk_type(index):
	var id_type_list = World_Helper.get_component_property_list("id", "id_type")
	var atk_id_type = id_type_list[index]
	var atk_type = base.atk_type.NORMAL
	if atk_id_type == base.type.PEOPLE:
		atk_type = base.atk_type.SKILL
	return atk_type

func update(delta):
	if World_Helper.game_state_flag == base.game_state.FIGHT:
		var attack_index_list = World_Helper.get_attack_index_list()
		
		var hp_list = World_Helper.get_component_property_list("hp", "hp")
		
		var length = attack_index_list.size()
		var count = 0
		# 攻击敌方单位
		for index in attack_index_list:
			# 选择攻击方式（默认物理攻击，技能、道具为主动使用）
			var is_do = false
			var atk_type = _get_atk_type(index)
			if atk_type == base.atk_type.NORMAL:
				# 物理攻击
				is_do = _do_attack(index)
			elif atk_type == base.atk_type.PROP:
				# 道具攻击
				is_do = _do_prop_attack(index)
			elif atk_type == base.atk_type.SKILL:
				# 技能攻击
				is_do = _do_skill_attack(index)
			if is_do:
				count += 1
			# 更新对应数据
		if count != length:
			Log_Helper.log(["[attack] ----->> no match atk count ", count, "/", length])
			if World_Helper.game_state_flag == base.game_state.FIGHT:
				World_Helper.game_state_flag = base.game_state.MOVE
