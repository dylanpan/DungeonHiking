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
	if !_start_move_flag and World_Helper.game_state_flag == base.game_state.MOVE:
		Log_Helper.log(["[move] system run ----->> "])
		_start_move_flag = true
		
		var speed_list = World_Helper.get_component_property_list("speed", "speed")
		var hp_list = World_Helper.get_component_property_list("hp", "hp")
		var last_distance_list = World_Helper.get_component_property_list("speed", "last_distance")
		var length = speed_list.size()
		var max_distance = 1000.0
		var tmp_time = []
		
		# 记录所有单位的移动距离和时间
		var move_data = []
		for index in range(length):
			var speed = speed_list[index]
			var hp = hp_list[index]
			if hp > 0:
				var last_distance = last_distance_list[index]
				var time = (max_distance - last_distance) / speed
				tmp_time.append(time)
				move_data.append({
					"index": index,
					"from_distance": last_distance,
					"speed": speed,
					"time": time
				})
			else:
				tmp_time.append(0)
		
		# tmp_time 中 index 为攻击单位，value 为时间
		# 查询其中时间最短的为发起攻击单位，同时需要累计在发起攻击单位的移动时间内其他攻击单位的移动距离
		# 获取最快到达的时间
		var min_time = tmp_time[0]
		var min_indexs = []
		for index in range(tmp_time.size()):
			var time = tmp_time[index]
			if time < min_time and time > 0:
				min_time = time
				min_indexs.clear()
				if hp_list[index] > 0:
					min_indexs.append(index)
			elif time == min_time and time > 0:
				if hp_list[index] > 0:
					min_indexs.append(index)
			elif 0 == min_time and time > 0:
				min_time = time
				if hp_list[index] > 0:
					min_indexs.append(index)
		
		# 为每个单位生成移动动画数据
		for data in move_data:
			var index = data.index
			var from_distance = data.from_distance 
			var speed = data.speed
			var time = min_time
			
			# 计算移动距离
			var to_distance
			if index in min_indexs:
				to_distance = max_distance
				last_distance_list[index] = 0
			else:
				to_distance = min(from_distance + time * speed, max_distance)
				last_distance_list[index] = to_distance
				
			# 添加移动动画数据
			World_Helper.add_animate({
				"type": base.animate_type.MOVE,
				"from_index": index,
				"extra_data": {
					"from_distance": from_distance,
					"to_distance": to_distance,
					"speed": speed
				}
			})
			
		World_Helper.set_attack_index_list(min_indexs)
		Log_Helper.log(["[move] last_distance: ", last_distance_list, ", attack index: ", min_indexs])
		
		# 切换到动画状态播放移动动画
		World_Helper.game_state_flag = base.game_state.ANIMATE 
		_start_move_flag = false
