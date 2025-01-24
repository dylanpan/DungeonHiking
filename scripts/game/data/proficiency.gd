class_name Proficiency

# 添加内容
#{
#	id: 1, // 技能ID
#	value: 10, // 使用技能熟练度记录
#}
var _monsters := []
var _equipments := []
var _skills := []
var _cuisines := []
#region 击杀怪物熟练度记录
func add_monster(_id, _value) -> void:
	_monsters.append({
		id = _id,
		value = _value
	})
	
func is_monster_ok(id) -> bool:
	var is_ok := false
	for data in _monsters:
		if data and data.id == id:
			# TODO 获取配置表中的熟练度进行比较
			data.value
	return is_ok
	
#endregion

#region 使用装备熟练度记录
func add_equipment(_id, _value) -> void:
	_equipments.append({
		id = _id,
		value = _value
	})
	
func is_equipment_ok(id) -> bool:
	var is_ok := false
	for data in _equipments:
		if data and data.id == id:
			# TODO 获取配置表中的熟练度进行比较
			data.value
	return is_ok
	
#endregion

#region 使用技能熟练度记录
func add_skill(_id, _value) -> void:
	_skills.append({
		id = _id,
		value = _value
	})
	
func is_skill_ok(id) -> bool:
	var is_ok := false
	for data in _skills:
		if data and data.id == id:
			# TODO 获取配置表中的熟练度进行比较
			data.value
	return is_ok
	
#endregion

#region 制作料理熟练度记录
func add_cuisine(_id, _value) -> void:
	_cuisines.append({
		id = _id,
		value = _value
	})
	
func is_cuisine_ok(id) -> bool:
	var is_ok := false
	for data in _cuisines:
		if data and data.id == id:
			# TODO 获取配置表中的熟练度进行比较
			data.value
	return is_ok
	
#endregion
