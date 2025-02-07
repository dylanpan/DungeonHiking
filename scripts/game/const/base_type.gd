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

enum atk_type {
	## 普通攻击
	NORMAL = 1,
	## 道具攻击
	PROP = 2,
	## 技能攻击
	SKILL = 3,
}

enum game_state {
	NONE = 1,
	PRE_START = 2,
	MOVE = 3,
	FIGHT = 4,
	END = 5,
}
