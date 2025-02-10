class_name base
## 游戏内需要使用的常量、枚举

## 游戏内出现的类型枚举
enum type {
	## 无
	NONE = 0, 
	## 角色
	PEOPLE = 1, 
	## 怪物
	MONSTER = 2, 
	## 装备
	EQUIPMENT = 3, 
	## 料理
	CUISINE = 4, 
	## 技能
	SKILL = 5, 
	## 道具
	ITEM = 6, 
}

## 游戏内出现的攻击类型枚举
enum atk_type {
	## 普通攻击
	NORMAL = 1,
	## 道具攻击
	PROP = 2,
	## 技能攻击
	SKILL = 3,
}

## 游戏状态枚举
enum game_state {
	NONE = 1,
	PRE_START = 2,
	MOVE = 3,
	BUFF = 4,
	FIGHT = 5,
	USE_PROP = 6,
	END = 7,
}

## 游戏内出现的 buff 类型枚举
enum buff_type {
	## 无
	NONE = 1,
	## 晕眩
	STUN = 2,
	## 沉默
	SILENCE = 3,
	## 弱化
	WEAKEN = 4,
	## 免疫
	IMMUNITY = 5,
	## 流血
	BLEED = 6,
	## 持续土伤
	EARTH_HIT = 7,
	## 持续雷伤
	THUNDER_HIT = 8,
	## 持续火伤
	FIRE_HIT = 9,
	## 持续风伤
	WIND_HIT = 10,
}
