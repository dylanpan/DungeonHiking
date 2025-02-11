class_name World_Helper

#region 游戏状态管理
static var _game_state_flag: base.game_state = base.game_state.NONE
static var _previous_state: base.game_state = base.game_state.NONE

## 游戏状态标识
static var game_state_flag: base.game_state = base.game_state.NONE:
	get:
		return _game_state_flag
	set(value):
		# 切换状态时记录前一个状态
		if value != _game_state_flag:
			_previous_state = _game_state_flag
			_game_state_flag = value

## 获取前一个状态
static func get_previous_state() -> base.game_state:
	return _previous_state

## 清除状态记录
static func clear_previous_state() -> void:
	_previous_state = base.game_state.NONE
#endregion

static var _world_components_map: Dictionary = {}
static func add_component(component: I_Component):
	var components: Array[I_Component] = []
	var index = -1
	if component.name in _world_components_map:
		components = _world_components_map[component.name]
	if not component in components:
		components.append(component)
		index = components.size() - 1
		var property_list = component.get_property_list()
		for prop in property_list:
			var name = prop.name
			if name != "RefCounted" and name != "script" and name != "name" and (not name.ends_with(".gd")):
				var value = component.get(name)
				add_component_property(index, component.name, name, value)
	_world_components_map[component.name] = components
	return index

static func get_components(name: String) -> Array[I_Component]:
	var components: Array[I_Component] = []
	if name in _world_components_map:
		components = _world_components_map[name]
	return components

static func get_world_components_map():
	return _world_components_map

static var _world_component_property_map: Dictionary = {}
static func add_component_property(index: int, component_name: String, property_name: String, property_value):
	if component_name in _world_component_property_map:
		var property_list_map = _world_component_property_map[component_name]
		if property_name in property_list_map:
			var property_list: Array = property_list_map[property_name]
			if index < property_list.size():
				property_list[index] = property_value
			else:
				property_list.append(property_value)
		else:
			var property_list = [property_value]
			_world_component_property_map[component_name][property_name] = property_list
	else:
		_world_component_property_map[component_name] = {}
		var property_list = [property_value]
		_world_component_property_map[component_name][property_name] = property_list

static func get_component_property_list(component_name: String, property_name: String) -> Array:
	var list := []
	if component_name in _world_component_property_map:
		list = _world_component_property_map[component_name][property_name]
	return list

static func get_component_property(index: int, component_name: String, property_name: String):
	var list = get_component_property_list(component_name, property_name)
	var value = list[index]
	return value

static func get_world_component_property_map():
	return _world_component_property_map

static var _component_name_map = {
	"atk": "Atk_Component",
	"atk_speed": "Atk_Component",
	"atk_distance": "Atk_Component",
	"atk_count": "Atk_Component",
	"skill_ids": "Skill_Component",
	"buff_ids": "Buff_Component",
	"prop_ids": "Prop_Component",
	"prop_ids_count": "Prop_Component",
	"counter_rate": "Counter_Component",
	"critical_rate": "Critical_Component",
	"critical_atk": "Critical_Component",
	"def": "Def_Component",
	"dodge": "Dodge_Component",
	"earth_element_atk": "Earth_Element_Component",
	"earth_element_def": "Earth_Element_Component",
	"fire_element_atk": "Fire_Element_Component",
	"fire_element_def": "Fire_Element_Component",
	"thunder_element_atk": "Thunder_Element_Component",
	"thunder_element_def": "Thunder_Element_Component",
	"wind_element_atk": "Wind_Element_Component",
	"wind_element_def": "Wind_Element_Component",
	"exp": "Exp_Component",
	"hp": "Hp_Component",
	"level": "Level_Component",
	"mana": "Mana_Component",
	"shield": "Shield_Component",
	"speed": "Speed_Component",
}

static func get_component_name(key: String):
	var name = ""
	if key in _component_name_map:
		name = _component_name_map[key]
	return name

static func instantiate_class(_class_name: String) -> Object:
	# 尝试实例化内置类
	if ClassDB.class_exists(_class_name) and ClassDB.can_instantiate(_class_name):
		return ClassDB.instantiate(_class_name)
	
	# 尝试加载自定义类
	var global_classes = ProjectSettings.get_global_class_list()
	for global_class in global_classes:
		if global_class["class"] == _class_name:
			var script_path = global_class["path"]
			var script = load(script_path)
			if script:
				return script.new()
	
	return null

static func create_component(key: String):
	var name = get_component_name(key)
	var instance = instantiate_class(name)
	return instance

#region 全局数据记录

#region 攻击单位
# 攻击单位由 move_system 中移动得到
static var _attack_index_list := []
static func set_attack_index_list(value: Array):
	_attack_index_list = value

static func get_attack_index_list() -> Array:
	return _attack_index_list
#endregion

#region 使用技能
# 技能使用由玩家主动使用得到
static var _skill_index_dict := {}
static func set_skill_index_dict(value: Dictionary):
	_skill_index_dict = value

static func set_skill_index_by_key(key: int, value: int):
	_skill_index_dict[key] = value

static func get_skill_index_dict() -> Dictionary:
	return _skill_index_dict
#endregion

#region 使用道具
# 道具使用由玩家主动使用得到
static var _prop_index_dict := {}
static func set_prop_index_dict(value: Dictionary):
	_prop_index_dict = value

static func set_prop_index_by_key(key: int, value: int):
	_prop_index_dict[key] = value

static func get_prop_index_dict() -> Dictionary:
	return _prop_index_dict
#endregion

#endregion

#region Buff 相关数据处理
# 修改为二维映射: entity_index -> (buff_id -> turns)
static var _buff_turns_map := {} 

# 初始化指定单位的buff回合数
static func init_buff_turns(index: int, buff_id: String):
	# 确保实体的buff记录存在
	if not index in _buff_turns_map:
		_buff_turns_map[index] = {}
	
	# 初始化该实体的指定buff回合数
	if not buff_id in _buff_turns_map[index]:
		var buff_meta = Meta_Helper.get_buff(buff_id)
		_buff_turns_map[index][buff_id] = buff_meta["turn"]

# 获取指定单位的buff剩余回合数
static func get_buff_turns(index: int, buff_id: String) -> int:
	var turns = 0
	if index in _buff_turns_map and buff_id in _buff_turns_map[index]:
		turns = _buff_turns_map[index][buff_id]
	return turns

# 获取指定单位的buff列表
static func get_buff_ids_turns(index: int) -> Dictionary:
	var turns := {}
	if index in _buff_turns_map:
		turns = _buff_turns_map[index]
	return turns

# 减少指定单位的buff回合数
static func decrease_buff_turns(index: int, buff_id: String) -> void:
	if index in _buff_turns_map and buff_id in _buff_turns_map[index]:
		_buff_turns_map[index][buff_id] -= 1
		if _buff_turns_map[index][buff_id] <= 0:
			_buff_turns_map[index].erase(buff_id)
			# 如果该实体没有任何buff了,清理掉实体记录
			if _buff_turns_map[index].is_empty():
				_buff_turns_map.erase(index)

# 清理指定单位的所有buff记录
static func clear_entity_buff_turns(index: int) -> void:
	if index in _buff_turns_map:
		_buff_turns_map.erase(index)
#endregion

#region Buff 状态标记
static var _stun_list := []
static var _silence_list := []
static var _immunity_list := []

# 无法移动
static func set_stun(index: int):
	if not index in _stun_list:
		_stun_list.append(index)

static func is_stun(index: int) -> bool:
	return index in _stun_list

static func clear_stun(index: int = -1):
	if index >= 0:
		# 清理指定单位的晕眩状态
		_stun_list.erase(index)
	else:
		# 清理所有单位的晕眩状态
		_stun_list.clear()

# 无法使用技能
static func set_silence(index: int):
	if not index in _silence_list:
		_silence_list.append(index)

static func is_silence(index: int) -> bool:
	return index in _silence_list

static func clear_silence(index: int = -1):
	if index >= 0:
		# 清理指定单位的沉默状态
		_silence_list.erase(index)
	else:
		# 清理所有单位的沉默状态
		_silence_list.clear()

# 免疫伤害
static func set_immunity(index: int):
	if not index in _immunity_list:
		_immunity_list.append(index)

static func is_immunity(index: int) -> bool:
	return index in _immunity_list

static func clear_immunity(index: int = -1):
	if index >= 0:
		# 清理指定单位的免疫状态
		_immunity_list.erase(index)
	else:
		# 清理所有单位的免疫状态
		_immunity_list.clear()

# 清理所有buff状态
static func clear_buff_states(index: int = -1):
	if index >= 0:
		# 清理指定单位的所有buff状态
		clear_stun(index)
		clear_silence(index)
		clear_immunity(index)
	else:
		# 清理所有单位的所有buff状态
		_stun_list.clear()
		_silence_list.clear()
		_immunity_list.clear()
#endregion

#region 属性修改记录
static var _origin_property_map := {} # entity_index -> {component_name -> {property_name -> value}}

# 记录原始属性值
static func record_property(index: int, component_name: String, property_name: String, value) -> void:
	if not index in _origin_property_map:
		_origin_property_map[index] = {}
	if not component_name in _origin_property_map[index]:
		_origin_property_map[index][component_name] = {}
	_origin_property_map[index][component_name][property_name] = value

# 获取原始属性值
static func get_origin_property(index: int, component_name: String, property_name: String):
	if index in _origin_property_map and component_name in _origin_property_map[index]:
		return _origin_property_map[index][component_name][property_name]
	return null

# 清除属性记录
static func clear_property_record(index: int = -1) -> void:
	if index >= 0:
		_origin_property_map.erase(index)
	else:
		_origin_property_map.clear()

# 修改属性值(按百分比)
static func modify_property_by_percent(index: int, percent: float, properties: Array) -> void:
	for prop in properties:
		var component_name = prop[0]
		var property_name = prop[1]
		var property_list = get_component_property_list(component_name, property_name)
		var current_value = property_list[index]
		# 记录原始值
		record_property(index, component_name, property_name, current_value)
		# 应用修改
		property_list[index] = current_value * (1 - percent)
#endregion

#region 动画数据管理
# 动画数据结构:
# {
#   type: base.animate_type,	# 动画类型 
#   from_index: int,			# 发起者索引
#   to_index: int,				# 目标索引
#   value: float,				# 数值(伤害/治疗等)
#   buff_id: String,			# buff ID(如果有)
#   extra_data: Dictionary		# 额外数据
# }
static var _animate_list: Array[Dictionary] = []

# 添加动画数据
static func add_animate(animate_data: Dictionary) -> void:
	_animate_list.append(animate_data)

# 获取所有动画数据
static func get_animates() -> Array[Dictionary]:
	return _animate_list

# 获取并清除所有动画数据
static func pop_animates() -> Array[Dictionary]:
	var animates = _animate_list.duplicate()
	_animate_list.clear()
	return animates

# 清除所有动画数据  
static func clear_animates() -> void:
	_animate_list.clear()
#endregion

#region 打印日志
static func print_class_properties(obj: Object):
	var property_list = obj.get_property_list()
	for prop in property_list:
		var name = prop.name
		var value = obj.get(name)
		Log_Helper.log([name,": ",value])

static func print_dict_properties(obj: Dictionary):
	print("print_dict ", obj)
#endregion
