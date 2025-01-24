class_name World

var _system_list: Array[I_System] = []

func initSystem():
	_system_list.append(Initialize_System.new())
	_system_list.append(Move_System.new())
	_system_list.append(Attack_System.new())
	_system_list.append(Prop_System.new())
	_system_list.append(Calculate_System.new())
	_system_list.append(Animate_System.new())
	
	for system in _system_list:
		system.init()

func destroySystem():
	for system in _system_list:
		system.destroy()

func updateSystem(delta):
	for system in _system_list:
		system.update(delta)
