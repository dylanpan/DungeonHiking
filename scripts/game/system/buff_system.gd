class_name Buff_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

# 流血伤害 - 无视防御
func _effect_bleed(index: int, buff_id: String):
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var damage = buff_meta["value"]
	var desc = buff_meta["desc"]

	# 添加流血效果动画
	World_Helper.add_animate({
		"type": base.animate_type.BUFF_EFFECT,
		"to_index": index,
		"buff_id": buff_id,
		"value": damage
	})

	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", damage])
	hp_list[index] = max(0, hp_list[index] - damage)
	Log_Helper.log(["[buff] ----->> end hp: ", hp_list])

# 晕眩 - 无法行动
func _effect_stun(index: int, buff_id: String):
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var damage = buff_meta["value"]
	var desc = buff_meta["desc"]

	# 添加晕眩效果动画
	World_Helper.add_animate({
		"type": base.animate_type.BUFF_EFFECT,
		"to_index": index,
		"buff_id": buff_id,
	})

	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", damage])
	World_Helper.set_stun(index)

# 弱化 - 包括全体属性
func _effect_weak(index: int, buff_id: String):
	# 如果处于免疫状态,不能被弱化
	if World_Helper.is_immunity(index):
		Log_Helper.log(["[buff] ----->> ", index, " is immunity, cannot be weakened"])
		return
		
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var weaken_percent = buff_meta["value"] / 100.0
	var desc = buff_meta["desc"]
	
	# 添加弱化效果动画
	World_Helper.add_animate({
		"type": base.animate_type.BUFF_EFFECT,
		"to_index": index,
		"buff_id": buff_id,
		"value": weaken_percent * 100
	})
	
	# 定义需要弱化的属性列表
	var properties = [
		["atk", "atk"],
		["def", "def"],
		["earth_element", "earth_element_atk"],
		["earth_element", "earth_element_def"],
		["fire_element", "fire_element_atk"],
		["fire_element", "fire_element_def"],
		["thunder_element", "thunder_element_atk"],
		["thunder_element", "thunder_element_def"],
		["wind_element", "wind_element_atk"],
		["wind_element", "wind_element_def"]
	]
	
	# 应用弱化效果
	World_Helper.modify_property_by_percent(index, weaken_percent, properties)
	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, " by ", weaken_percent * 100, "%"])

# 沉默效果 - 无法使用技能
func _effect_silence(index: int, buff_id: String):
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var desc = buff_meta["desc"]
	
	# 添加沉默效果动画
	World_Helper.add_animate({
		"type": base.animate_type.BUFF_EFFECT,
		"to_index": index,
		"buff_id": buff_id,
	})

	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc])
	# 添加沉默状态标记,在attack_system中判断是否可以使用技能
	World_Helper.set_silence(index)

# 免疫效果 - 免疫所有伤害
func _effect_immunity(index: int, buff_id: String):
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var desc = buff_meta["desc"]
	
	# 添加被免疫的动画效果
	World_Helper.add_animate({
		"type": base.animate_type.BUFF_EFFECT,
		"to_index": index,
		"buff_id": buff_id,
		"extra_data": {
			"is_immunity": true
		}
	})

	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc])
	
	# 设置免疫状态
	World_Helper.set_immunity(index)
	
	# 清除其他状态标记和属性修改
	World_Helper.clear_stun(index)
	World_Helper.clear_silence(index)
	
	# 恢复被弱化的属性
	var properties = [
		["atk", "atk"],
		["def", "def"],
		["earth_element", "earth_element_atk"],
		["earth_element", "earth_element_def"],
		["fire_element", "fire_element_atk"],
		["fire_element", "fire_element_def"],
		["thunder_element", "thunder_element_atk"],
		["thunder_element", "thunder_element_def"],
		["wind_element", "wind_element_atk"],
		["wind_element", "wind_element_def"]
	]
	
	for prop in properties:
		var component_name = prop[0]
		var property_name = prop[1]
		var origin_value = World_Helper.get_origin_property(index, component_name, property_name)
		if origin_value != null:
			var property_list = World_Helper.get_component_property_list(component_name, property_name)
			property_list[index] = origin_value
	
	# 清除属性记录
	World_Helper.clear_property_record(index)

# 持续元素属性伤害
func _effect_element_hit(index: int, buff_id: String, element_key: String, element_def_type: String):
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var element_def_list = World_Helper.get_component_property_list(element_key, element_def_type)
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var buff_type = buff_meta["type"]
	var element_atk = buff_meta["value"]
	var element_def = element_def_list[index]
	var element_def_max = 1000.0
	var element_damage = element_atk * (1 - element_def / element_def_max)
	var desc = buff_meta["desc"]
	
	# 添加持续元素属性伤害效果动画
	World_Helper.add_animate({
		"type": base.animate_type.BUFF_EFFECT,
		"to_index": index,
		"buff_id": buff_id,
		"extra_data": {
			"value": element_damage
		}
	})

	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", element_damage])
	hp_list[index] = max(0, hp_list[index] - element_damage)
	Log_Helper.log(["[buff] ----->> end hp: ", hp_list])

# 持续土伤
func _effect_earth_hit(index: int, buff_id: String):
	_effect_element_hit(index, buff_id, "earth_element", "earth_element_def")

# 持续雷伤
func _effect_thunder_hit(index: int, buff_id: String):
	_effect_element_hit(index, buff_id, "thunder_element", "thunder_element_def")

# 持续火伤 
func _effect_fire_hit(index: int, buff_id: String):
	_effect_element_hit(index, buff_id, "fire_element", "fire_element_def")

# 持续风伤
func _effect_wind_hit(index: int, buff_id: String):
	_effect_element_hit(index, buff_id, "wind_element", "wind_element_def")

func _process_buff_effect(index: int, buff_id: String):
	# 通过buff_id获取buff配置
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var buff_type = buff_meta["type"]

	# 如果单位处于免疫状态,且不是免疫buff本身,则不处理效果
	if World_Helper.is_immunity(index) and buff_type != base.buff_type.IMMUNITY:
		# 添加被免疫的动画效果
		World_Helper.add_animate({
			"type": base.animate_type.BUFF_EFFECT,
			"to_index": index,
			"buff_id": buff_id,
			"extra_data": {
				"is_immunity": true
			}
		})
		Log_Helper.log(["[buff] ----->> ", index, " is immunity, ignore buff: ", buff_meta["desc"]])
		return

	# 根据buff类型处理效果
	match buff_type:
		base.buff_type.STUN:
			_effect_stun(index, buff_id)
		base.buff_type.SILENCE:
			_effect_silence(index, buff_id)
		base.buff_type.WEAKEN:
			_effect_weak(index, buff_id)
		base.buff_type.IMMUNITY:
			_effect_immunity(index, buff_id)
		base.buff_type.BLEED:
			_effect_bleed(index, buff_id)
		base.buff_type.EARTH_HIT:
			_effect_earth_hit(index, buff_id)
		base.buff_type.THUNDER_HIT:
			_effect_thunder_hit(index, buff_id)
		base.buff_type.FIRE_HIT:
			_effect_fire_hit(index, buff_id)
		base.buff_type.WIND_HIT:
			_effect_wind_hit(index, buff_id)
		# 其他buff类型...

func _update_buff_turns():
	var attack_index_list = World_Helper.get_attack_index_list()
	var buff_ids_list = World_Helper.get_component_property_list("buff", "buff_ids")
	for index in attack_index_list:
		var buff_ids = buff_ids_list[index]
		var i = buff_ids.size() - 1
		var buff_ids_turns = World_Helper.get_buff_ids_turns(index)
		Log_Helper.log(["[buff] ----->> ", index ," buff turn: ", buff_ids_turns])
		while i >= 0:
			var buff_id = buff_ids[i]
			
			# 确保buff回合数已初始化
			World_Helper.init_buff_turns(index, buff_id)
			# 处理buff效果
			_process_buff_effect(index, buff_id)
			# 减少回合数
			World_Helper.decrease_buff_turns(index, buff_id)
			
			# 移除过期的buff
			if World_Helper.get_buff_turns(index, buff_id) <= 0:
				buff_ids.remove_at(i)
				buff_ids_list[index] = buff_ids
			
			i -= 1

func update(delta):
	if World_Helper.game_state_flag == base.game_state.BUFF:
		Log_Helper.log(["[buff] system run ----->> "])
		_update_buff_turns()
		# 如果有动画需要播放,切换到动画状态
		if not World_Helper._animate_list.is_empty():
			World_Helper.game_state_flag = base.game_state.ANIMATE
		else:
			# 没有动画直接切换到战斗状态
			# TEST data: sim use prop
			World_Helper.set_prop_index_by_key(1, 1)
			World_Helper.game_state_flag = base.game_state.FIGHT
