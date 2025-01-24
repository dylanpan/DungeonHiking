### 主要内容
* 向下的地牢探索，战斗结果是获取怪物身上的有用材料（去做料理）、装备（熟练度增加道具效果，多个装备组合产生效果）、经验（根据携带装备会有对应的技能路线，三选一技能）、无用材料（货币）
* 死亡后所有属性重置，仅保留烹饪技巧、装备熟练度
* 怪物都有弱点的致命打击
* 主玩法是和怪物对战，对战期间可以随时从背包中拿出料理
* 形式是轮流攻击/攻速攻击/攻击后移动速度攻击
* a  bbbb
* 副玩法是搭配对应的材料进行合成（合成达到一定数量增加烹饪技巧），料理 = 材料A + 材料B + 烹饪技巧
* 料理可以作为对应怪物的针对弱点的打击道具，角色的恢复、增强，带错料理进行战斗会增强怪物（增加怪物的二阶变声会得到更强的奖励）

#### 拆解
##### 1 游戏背景
- 游戏开始先准备好背包的物品，生命值消耗完前返回为胜利
- 途中会遭遇怪物，击败可获得掉落奖励
- 途中会遭遇怪物，可逃跑
- 途中每天移动都会扣减生命值（可扩展其他属性，用作san值发挥）
- 向右前进遭遇怪物，可增加地图提供可选方向
- 和怪物对战使用的是料理

相当于料理制作就是武器制作
	- 料理的耐久度表示使用次数，用一次少一次
	- 料理分投掷和近战
	- 投掷用于一次效果，上 Buff/Debuff
	- 近战相当于增加了有限次数的普通攻击

init（初始化组件） 
	-> move（对应组件移动数据更新） 
	-> attack（判断物理/技能攻击与被物理/技能攻击） 
	-> prop（使用道具更新组件数据） 
	-> calcu（条件更新各个组件的数据） 
	-> ani（对应组件会有对应的动画） 

##### 2 怪物
1. 掉落
	- 有用材料（去做料理）
	- 装备（熟练度增加道具效果，多个装备组合产生效果）
	- 经验（根据携带装备会有对应的技能路线，三选一技能）
	- 无用材料（货币）
2. 造型
	- 和食物相融合
	- 参考美食俘虏
3. 技能
4. 战斗属性
	- 血量
	- 攻击
	- 攻击速度
	- 攻击距离
	- 防御
	- 护盾
	- 闪避
	- 元素属性
	- 元素抗性
	- 暴击攻击
	- 暴击率
	- 反击率
	- 经验
	- 等级
	- 类型

##### 3 角色
1. 战斗属性
	- 血量
	- 攻击
	- 攻击速度
	- 防御
	- 护盾
	- 元素属性
	- 元素抗性
	- 暴击攻击
	- 暴击率
	- 反击率
	- 经验
	- 等级
	- 类型
	- 攻击距离
2. 装备
	- 每最后一击杀怪物增加对应熟练度
	- 穿戴后增加属性
	- 组合装备会激发技能
3. 技能
4. 造型
	- 无用之人
	- 穿戴装备后进行更新
5. 背包
6. 烹饪属性
	- 经验
	- 类型等级
7. 装备属性
	- 经验
	- 等级
	- 类型
	- 攻击速度
	- 攻击距离

##### 4 料理
1. 合成材料
2. 所需烹饪技能等级
3. 合成公式

##### 5 装备
1. 属性
	- 血量
	- 攻击
	- 防御
	- 护盾
	- 元素属性
	- 元素抗性
	- 暴击攻击
	- 暴击率
	- 反击率
	- 经验
	- 等级
	- 类型
	- 攻击距离
2. 造型
3. 技能

##### 6 技能

##### 7 仓库

##### 8 图鉴
