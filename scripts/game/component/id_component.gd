class_name Id_Component
## ID组件
extends I_Component

func _init():
	name = "id"

## 对应类型ID
var id: int 
## 对应类型配置表ID
var meta_id: String 
## 对应类型
var id_type: base.type = base.type.NONE
