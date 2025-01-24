class_name Meta_Helper
## 配置表管理

var _people_map := {}
var _monster_map := {}

func init():
	_people_map = {
		"1": {
			"id": "1",
			"level": 1,
			"exp": 10,
			"hp": 1,
			"mana": 1,
			"def": 100,
			"shield": 1,
			"atk": 10,
			"atk_speed": 1,
			"atk_distance": 1,
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
		}
	}
	_monster_map = {
		"1": {
			"id": "1",
			"level": 10,
			"exp": 20,
			"hp": 100,
			"mana": 100,
			"def": 10,
			"shield": 20,
			"atk": 1,
			"atk_speed": 1,
			"atk_distance": 1,
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

func get_people(id: String):
	var meta := {}
	if id in _people_map:
		meta = _people_map[id]
	return meta

func get_monster(id: String):
	var meta := {}
	if id in _monster_map:
		meta = _monster_map[id]
	return meta
