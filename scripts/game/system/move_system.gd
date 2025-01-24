class_name Move_System
extends I_System

var list := []
var _start_move_flag: bool = false
var count = 0

func init():
	list = []

func destroy():
	list.clear()

# 假定一条路径，所有单位开始向前移动，谁先到终点，谁进行攻击，然后重回起点，其他单位保持原地继续进行
func update(delta):
	if !_start_move_flag and World_Helper.game_state_flag == base.game_state.PRE_START:
		# 测试轮换
		if count <= 9:
			count += 1
		else:
			_start_move_flag = true
			World_Helper.game_state_flag = base.game_state.START
		
		var components = World_Helper.get_components("speed")
		var speed_list = World_Helper.get_component_property_list("speed", "speed")
		var last_distance_list = World_Helper.get_component_property_list("speed", "last_distance")
		var length = speed_list.size()
		var max_distance = 1000.0
		var tmp_time = []
		for index in range(length):
			var speed = speed_list[index]
			var last_distance = last_distance_list[index]
			var time = (max_distance - last_distance) / speed
			tmp_time.append(time)
		
		# tmp_time 中 index 为攻击单位，value 为时间
		# 查询其中时间最短的为发起攻击单位，同时需要累计在发起攻击单位的移动时间内其他攻击单位的移动距离
		var min_time = tmp_time[0]
		# 获取到达终点的单位数组
		var min_indexs = []
		for index in range(tmp_time.size()):
			var time = tmp_time[index]
			if time < min_time:
				min_time = time
				min_indexs.clear()
				min_indexs.append(index)
			elif time == min_time:
				min_indexs.append(index)
		World_Helper.set_attack_index_list(min_indexs)
		
		for index in range(tmp_time.size()):
			if index in min_indexs:
				last_distance_list[index] = 0
				#components[index].last_distance = 0
			else:
				var last_distance = last_distance_list[index]
				var speed = speed_list[index]
				var distance = min(last_distance + min_time * speed, max_distance)
				last_distance_list[index] = distance
				#components[index].last_distance = distance
		print("last_distance: ", last_distance_list, ", attack index: ", min_indexs)
