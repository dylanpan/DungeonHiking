class_name World_Util

static func get_uuid() -> String:
	var crypto = Crypto.new()
	var random_bytes = crypto.generate_random_bytes(16)
	var uuid = ""
	for i in range(16):
		uuid += "%02x" % random_bytes[i]
		if i == 3 or i == 5 or i == 7 or i == 9:
			uuid += "-"
	return uuid
