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

enum game_state {
	NONE = 1,
	PRE_START = 2,
	START = 3,
	END = 4,
}
