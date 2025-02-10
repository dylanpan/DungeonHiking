class_name Animate_System
extends I_System

var _current_animate_index := -1
var _animate_duration := 1.0  # 每个动画播放时长
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
	Log_Helper.log([
		"[animate] Buff Effect on ",
		animate.to_index,
		" buff_id: ",
		animate.buff_id
	])
	# TODO: 实现具体动画效果

func _play_death(animate: Dictionary) -> void:
	Log_Helper.log([
		"[animate] Death of ",
		animate.to_index
	])
	# TODO: 实现具体动画效果

func update(delta):
	# 状态是动画播放时
	if World_Helper.game_state_flag == base.game_state.ANIMATE:
		# 获取新的动画数据
		if _current_animate_index < 0:
			_current_animates = World_Helper.pop_animates()
			if _current_animates.is_empty():
				# 没有动画数据,切换到移动状态
				World_Helper.game_state_flag = base.game_state.MOVE
				return
			_current_animate_index = 0
			_current_time = 0
			_play_current_animate()
		
		# 更新当前动画
		_current_time += delta
		if _current_time >= _animate_duration:
			_current_animate_index += 1
			if _current_animate_index >= _current_animates.size():
				# 所有动画播放完成
				_reset()
				World_Helper.game_state_flag = base.game_state.MOVE
			else:
				_current_time = 0
				_play_current_animate()
