class_name Meta_Helper
## 配置表管理

static var _people_map := {}
static var _monster_map := {}
static var _skill_map := {}
static var _prop_map := {}
static var _buff_map := {} # 新增 buff 配置映射

static func init():
	_people_map = {
		"1": {
			"id": "1",
			"level": 1,
			"exp": 10,
			"skill_ids": ["1"],
			"prop_ids": ["1","2"],
			"prop_ids_count": [2,1],
			"buff_ids": [],
			"hp": 110,
			"mana": 100,
			"def": 100,
			"shield": 1,
			"atk": 10,
			"atk_speed": 1,
			"atk_distance": 2,
			"atk_count": 1,
			"counter_rate": 1,
			"critical_rate": 30,
			"critical_atk": 10,
			"dodge": 1,
			"speed": 10,
			"earth_element_atk": 1,
			"earth_element_def": 1,
			"fire_element_atk": 1,
			"fire_element_def": 1,
			"thunder_element_atk": 1,
			"thunder_element_def": 1,
			"wind_element_atk": 1,
			"wind_element_def": 1,
			"accuracy": 100,
			"hp_heal_rate": 1,
			"mana_heal_rate": 1,
		}
	}
	_monster_map = {
		"1": {
			"id": "1",
			"level": 10,
			"exp": 20,
			"skill_ids": [],
			"prop_ids": [],
			"prop_ids_count": [],
			"buff_ids": [],
			"hp": 150,
			"mana": 100,
			"def": 10,
			"shield": 20,
			"atk": 40,
			"atk_speed": 1,
			"atk_distance": 2,
			"atk_count": 1,
			"counter_rate": 1,
			"critical_rate": 1,
			"critical_atk": 1,
			"dodge": 1,
			"speed": 4,
			"earth_element_atk": 1,
			"earth_element_def": 1,
			"fire_element_atk": 1,
			"fire_element_def": 1,
			"thunder_element_atk": 1,
			"thunder_element_def": 1,
			"wind_element_atk": 1,
			"wind_element_def": 1,
		}
	}
	_skill_map = {
		"1": {
			"id": "1",
			"mana": 80,
			"atk": 1,
			"def": 0,
			"atk_distance": 3,
			"atk_count": 2,
			"earth_element_atk": 0,
			"earth_element_def": 0,
			"fire_element_atk": 20,
			"fire_element_def": 0,
			"thunder_element_atk": 0,
			"thunder_element_def": 0,
			"wind_element_atk": 0,
			"wind_element_def": 0,
			"buff_id": "3"
		}
	}
	_prop_map = {
		"1": {
			"id": "1",
			"atk": 1,
			"def": 0,
			"atk_distance": 2,
			"atk_count": 2,
			"earth_element_atk": 0,
			"earth_element_def": 0,
			"fire_element_atk": 0,
			"fire_element_def": 0,
			"thunder_element_atk": 30,
			"thunder_element_def": 0,
			"wind_element_atk": 0,
			"wind_element_def": 0,
			"buff_id": ""
		},
		"2": {
			"id": "2",
			"atk": 1,
			"def": 0,
			"atk_distance": 2,
			"atk_count": 2,
			"earth_element_atk": 0,
			"earth_element_def": 0,
			"fire_element_atk": 0,
			"fire_element_def": 0,
			"thunder_element_atk": 3,
			"thunder_element_def": 0,
			"wind_element_atk": 0,
			"wind_element_def": 0,
			"buff_id": "5"
		}
	}
	_buff_map = {
		"1": {
			"id": "1",
			"turn": 3,          # 持续回合数
			"type": base.buff_type.STUN,  # buff类型
			"desc": "STUN",      # buff描述
			"value": 0,         # buff效果值(晕眩类型不需要)
		},
		"2": {
			"id": "2",
			"turn": 3, 
			"type": base.buff_type.SILENCE,
			"desc": "SILENCE",
			"value": 0,
		},
		"3": {
			"id": "3",
			"turn": 3,
			"type": base.buff_type.WEAKEN,
			"desc": "WEAKEN",
			"value": 10,        # 降低全属性5%
		},
		"4": {
			"id": "4",
			"turn": 3,
			"type": base.buff_type.IMMUNITY,
			"desc": "IMMUNITY",
			"value": 0,
		},
		"5": {
			"id": "5",
			"turn": 3,
			"type": base.buff_type.BLEED,
			"desc": "BLEED",
			"value": 10,        # 每回合伤害
		},
		"6": {
			"id": "6",
			"turn": 4,
			"type": base.buff_type.EARTH_HIT,
			"desc": "EARTH_HIT",
			"value": 0,        # 每回合土属性伤害
		},
		"7": {
			"id": "7",
			"turn": 4,
			"type": base.buff_type.THUNDER_HIT,
			"desc": "THUNDER_HIT",
			"value": 0,        # 每回合雷属性伤害
		},
		"8": {
			"id": "8", 
			"turn": 4,
			"type": base.buff_type.FIRE_HIT,
			"desc": "FIRE_HIT",
			"value": 10,        # 每回合火属性伤害
		},
		"9": {
			"id": "9", 
			"turn": 4,
			"type": base.buff_type.WIND_HIT,
			"desc": "WIND_HIT",
			"value": 10,        # 每回合风属性伤害
		},
	}

static func get_people(id: String):
	var meta := {}
	if id in _people_map:
		meta = _people_map[id]
	return meta

static func get_monster(id: String):
	var meta := {}
	if id in _monster_map:
		meta = _monster_map[id]
	return meta

static func get_skill(id: String):
	var meta := {}
	if id in _skill_map:
		meta = _skill_map[id]
	return meta

static func get_prop(id: String):
	var meta := {}
	if id in _prop_map:
		meta = _prop_map[id]
	return meta

# 新增获取buff配置的方法
static func get_buff(id: String) -> Dictionary:
	var meta := {}
	if id in _buff_map:
		meta = _buff_map[id]
	return meta
