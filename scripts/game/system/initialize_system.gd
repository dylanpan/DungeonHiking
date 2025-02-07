class_name Initialize_System
extends I_System

var list := []

func init():
	# 初始化标识
	list = []
	Meta_Helper.init()

func init_all_entities():
	# 初始化所有的实体，以及对应的组件
	# TODO 根据关卡配置表初始化
	_init_peoples()
	_init_monsters()

func _init_peoples():
	_get_people()
	_get_people()

func _get_people():
	var entity = Entity.new()
	entity.uuid = World_Util.get_uuid()
	
	var meta = Meta_Helper.get_people("1")
	_init_battle_component(entity, meta)
	
	var id_component = Id_Component.new()
	id_component.id_type = base.type.PEOPLE
	World_Helper.add_component(id_component)
	id_component.id = entity.id

func _init_monsters():
	_get_monster()
	_get_monster()

func _get_monster():
	var entity = Entity.new()
	entity.uuid = World_Util.get_uuid()
	
	var meta = Meta_Helper.get_monster("1")
	_init_battle_component(entity, meta)
	
	var id_component = Id_Component.new()
	id_component.id_type = base.type.MONSTER
	World_Helper.add_component(id_component)
	id_component.id = entity.id

func _init_battle_component(entity: Entity, meta: Dictionary):
	# 配置表对应更新
	var tmp_map = {}
	for key in meta:
		var value = meta[key]
		var _class_name = World_Helper.get_component_name(key)
		var _class_instance
		if _class_name in tmp_map:
			_class_instance = tmp_map[_class_name]
		else:
			_class_instance = World_Helper.create_component(key)
			if _class_instance:
				tmp_map[_class_name] = _class_instance 
		if _class_instance:
			var err = ClassDB.class_set_property(_class_instance, key, value)
			var name := ""
			if err:
				_class_instance.set(key, value)
				name = _class_instance.get("name")
			else:
				name = ClassDB.class_get_property(_class_instance, "name")
			
			var index = World_Helper.add_component(_class_instance)
			entity.id = index
			World_Helper.add_component_property(index, name, key, value)
			Log_Helper.log(["test _class_instance 1 - ", index, " ", _class_name, " ", key, " ", value, " ", err])
			World_Helper.print_class_properties(_class_instance)
	tmp_map.clear()

func destroy():
	# 销毁所有的实体、重置标识
	list.clear()

func update(delta):
	if World_Helper.game_state_flag == base.game_state.NONE:
		World_Helper.game_state_flag = base.game_state.PRE_START
		init_all_entities()
		var _tmp = World_Helper.get_world_component_property_map()
		World_Helper.print_dict_properties(_tmp)
		World_Helper.game_state_flag = base.game_state.MOVE
