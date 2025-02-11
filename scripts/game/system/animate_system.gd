class_name Animate_System
extends I_System

var _current_animate_index := -1
var _current_time := 0.0
var _current_animates: Array[Dictionary] = []

func init():
	_reset()

func destroy():
	_reset()

func _reset():
	_current_animate_index = -1
	_current_time = 0.0
	_current_animates.clear()

# 播放当前动画
func _play_current_animate() -> void:
	if _current_animate_index < 0 or _current_animate_index >= _current_animates.size():
		return
		
	var animate = _current_animates[_current_animate_index]
	match animate.type:
		base.animate_type.MOVE:
			_play_move(animate)
		base.animate_type.NORMAL_ATTACK:
			_play_normal_attack(animate)
		base.animate_type.SKILL_ATTACK:
			_play_skill_attack(animate)
		base.animate_type.PROP_ATTACK:
			_play_prop_attack(animate)
		base.animate_type.COUNTER_ATTACK:
			_play_counter_attack(animate)
		base.animate_type.DODGE:
			_play_dodge(animate)
		base.animate_type.SHIELD_HIT:
			_play_shield_hit(animate)
		base.animate_type.SHIELD_BREAK:
			_play_shield_break(animate)
		base.animate_type.HP_CHANGE:
			_play_hp_change(animate)
		base.animate_type.BUFF_EFFECT:
			_play_buff_effect(animate)
		base.animate_type.DEATH:
			_play_death(animate)

# 播放移动动画
func _play_move(animate: Dictionary) -> void:
	var from_distance = animate.extra_data.from_distance
	var to_distance = animate.extra_data.to_distance
	var speed = animate.extra_data.speed
	
	Log_Helper.log([
		"[animate] Move unit ",
		animate.from_index,
		" from ",
		from_distance,
		" to ",
		to_distance,
		" with speed ",
		speed
	])
	# TODO: 实现具体移动动画效果

func _play_normal_attack(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Normal Attack from ",
		animate.from_index,
		" to ",
		animate.to_index,
		" damage: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_skill_attack(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Skill Attack from ",
		animate.from_index,
		" to ",
		animate.to_index,
		" damage: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_prop_attack(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Prop Attack from ",
		animate.from_index,
		" to ",
		animate.to_index,
		" damage: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_counter_attack(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Counter Attack from ",
		animate.from_index,
		" to ",
		animate.to_index,
		" damage: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_dodge(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Dodge by ",
		animate.to_index
	])
	# TODO: 实现具体动画效果

func _play_shield_hit(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Shield Hit on ",
		animate.to_index,
		" damage: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_shield_break(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Shield Break on ",
		animate.to_index,
		" shield: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_hp_change(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] HP Change on ",
		animate.to_index,
		" value: ",
		animate.value
	])
	# TODO: 实现具体动画效果

func _play_buff_effect(animate: Dictionary) -> void:
	var buff_meta = Meta_Helper.get_buff(animate.buff_id)
	var buff_type = buff_meta["type"]
	var desc = buff_meta["desc"]
	var value = animate.value
	
	match buff_type:
		base.buff_type.STUN:
			Log_Helper.log([
				"[animate] Stun Effect on ",
				animate.to_index,
				" buff: ",
				desc
			])
			
		base.buff_type.SILENCE:
			Log_Helper.log([
				"[animate] Silence Effect on ",
				animate.to_index,
				" buff: ",
				desc
			])
			
		base.buff_type.WEAKEN:
			Log_Helper.log([
				"[animate] Weaken Effect on ",
				animate.to_index,
				" buff: ",
				desc,
				" value: ",
				value,
				"%"
			])
			
		base.buff_type.IMMUNITY:
			if animate.extra_data.get("is_immunity_gain", false):
				# 获得免疫状态
				Log_Helper.log([
					"[animate] Gained Immunity Effect on ",
					animate.to_index,
					" buff: ",
					desc
				])
			else:
				# 免疫了其他效果
				Log_Helper.log([
					"[animate] Immune Effect on ",
					animate.to_index,
					" immune buff: ",
					animate.buff_id,
					" type: ",
					desc
				])
			
		base.buff_type.BLEED:
			Log_Helper.log([
				"[animate] Bleed Effect on ",
				animate.to_index,
				" buff: ",
				desc,
				" damage: ",
				value
			])
			
		base.buff_type.EARTH_HIT:
			Log_Helper.log([
				"[animate] Earth Hit Effect on ",
				animate.to_index,
				" buff: ",
				desc,
				" damage: ",
				value
			])
			
		base.buff_type.THUNDER_HIT:
			Log_Helper.log([
				"[animate] Thunder Hit Effect on ",
				animate.to_index,
				" buff: ",
				desc,
				" damage: ",
				value
			])
			
		base.buff_type.FIRE_HIT:
			Log_Helper.log([
				"[animate] Fire Hit Effect on ",
				animate.to_index,
				" buff: ",
				desc,
				" damage: ",
				value
			])
			
		base.buff_type.WIND_HIT:
			Log_Helper.log([
				"[animate] Wind Hit Effect on ",
				animate.to_index,
				" buff: ",
				desc,
				" damage: ",
				value
			])
			
	# TODO: 实现具体动画效果

func _play_death(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Death of ",
		animate.to_index
	])
	# TODO: 实现具体动画效果

func _get_animate_duration(animate_data: Dictionary) -> float:
	# 如果动画数据中指定了时长就使用指定值
	if "duration" in animate_data:
		return animate_data.duration
	
	var duration = 1.0
	# 为不同类型的动画设置默认时长
	match animate_data.type:
		base.animate_type.MOVE:
			# 移动动画时长根据距离和速度计算
			var distance = animate_data.extra_data.to_distance - animate_data.extra_data.from_distance
			duration = distance / animate_data.extra_data.speed * 0.01
		base.animate_type.NORMAL_ATTACK:
			duration = 0.8  # 普通攻击较快
		base.animate_type.SKILL_ATTACK:
			duration = 1.2  # 技能攻击较慢
		base.animate_type.BUFF_EFFECT:
			duration = 1.0  # buff效果标准时长
		base.animate_type.DEATH:
			duration = 1.5  # 死亡动画较长
		_:
			duration = 1.0  # 默认时长
	return duration

func _handle_state_transition():
	var previous_state = World_Helper.get_previous_state()
	match previous_state:
		base.game_state.MOVE:
			World_Helper.game_state_flag = base.game_state.BUFF
		base.game_state.BUFF:
			World_Helper.game_state_flag = base.game_state.FIGHT
		base.game_state.FIGHT:
			World_Helper.game_state_flag = base.game_state.CALCULATE
		_:
			# 如果没有记录到前一个状态，默认切换到移动状态
			World_Helper.game_state_flag = base.game_state.MOVE
	
	Log_Helper.log(["[animate] handle state transition from ", World_Helper.get_state_name(previous_state), " to ", World_Helper.get_state_name(World_Helper.game_state_flag)])
	# 清除状态记录
	World_Helper.clear_previous_state()

func update(delta):
	# 状态是动画播放时
	if World_Helper.game_state_flag == base.game_state.ANIMATE:
		# 获取新的动画数据
		if _current_animate_index < 0:
			_current_animates = World_Helper.pop_animates()
			if _current_animates.is_empty():
				# 根据当前状态决定切换到哪个状态
				_handle_state_transition()
				return
			_current_animate_index = 0
			_current_time = 0
			_play_current_animate()
		
		# 更新当前动画
		var current_duration = _get_animate_duration(_current_animates[_current_animate_index])
		_current_time += delta
		if _current_time >= current_duration:
			_current_animate_index += 1
			if _current_animate_index >= _current_animates.size():
				# 所有动画播放完成
				_reset()
				# 根据当前状态决定切换到哪个状态
				_handle_state_transition()
			else:
				_current_time = 0
				_play_current_animate()
