class_name Buff_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

# 流血伤害
func _effect_bleed(index: int, buff_id: String):
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var damage = buff_meta["value"]
	var desc = buff_meta["desc"]
	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", damage])
	hp_list[index] = max(0, hp_list[index] - damage)
	Log_Helper.log(["[buff] ----->> end hp: ", hp_list])

# 晕眩 - 无法行动
func _effect_stun(index: int, buff_id: String):
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var damage = buff_meta["value"]
	var desc = buff_meta["desc"]
	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", damage])
	World_Helper.set_cannot_move(index)

# 持续火伤
func _effect_fire_hit(index: int, buff_id: String):
	# 持续火伤
	var hp_list = World_Helper.get_component_property_list("hp", "hp")
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var damage = buff_meta["value"]
	var desc = buff_meta["desc"]
	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", damage])
	hp_list[index] = max(0, hp_list[index] - damage)
	Log_Helper.log(["[buff] ----->> end hp: ", hp_list])

# 降低攻击力
func _effect_weak(index: int, buff_id: String):
	var atk_list = World_Helper.get_component_property_list("atk", "atk")
	var buff_meta = Meta_Helper.get_buff(buff_id)
	var damage = buff_meta["value"]
	var desc = buff_meta["desc"]
	Log_Helper.log(["[buff] ----->> ", index ," buff: ", desc, ", damage: ", damage])
	atk_list[index] = max(0, atk_list[index] - damage)

func _process_buff_effect(index: int, buff_id: String):
	# 通过buff_id获取buff配置
	var buff_meta = Meta_Helper.get_buff(buff_id)
	
	# 根据buff类型处理效果
	match buff_meta["type"]:
		base.buff_type.BLEED:
			_effect_bleed(index, buff_id)
		base.buff_type.STUN:
			_effect_stun(index, buff_id)
		base.buff_type.FIRE_HIT:
			_effect_fire_hit(index, buff_id)
		base.buff_type.WEAKEN:
			_effect_weak(index, buff_id)
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
		# TEST data: sim use prop
		World_Helper.set_prop_index_by_key(1, 1)
		World_Helper.game_state_flag = base.game_state.FIGHT
