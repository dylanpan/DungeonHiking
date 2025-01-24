class_name Log_Helper
## 输出日志信息

static func log(args):
	if typeof(args) == TYPE_ARRAY:
		var tmp = ""
		for arg in args:
			tmp += str(arg)
		print(tmp)
	else:
		print(args)
