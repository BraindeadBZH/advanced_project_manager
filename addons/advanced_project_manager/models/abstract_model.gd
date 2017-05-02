# class AbstractModel
extends Reference

class Constants extends "../constants.gd": func _init(): pass

# To override
func clear():
	pass

# To override
func _get_persist_config():
	return {}

# To override
func _get_model_type():
	return "AbstractModel"

# To override (Optional)
func _get_model_instance(model_type):
	return null

func serialize():
	var data = {}
	var config = _get_persist_config()
	for prop in config:
		var prop_config = config[prop]
		data[prop] = _to_json_value(get(prop), prop_config[Constants.PERSIST_CONFIG_TYPE], prop_config)
	return data

func deserialize(data):
	var config = _get_persist_config()
	for prop in config:
		var prop_config = config[prop]
		if !data.has(prop) || prop == Constants.PERSIST_TYPE_MODEL_TYPE: continue
		set(prop, _from_json_value(data[prop], prop_config[Constants.PERSIST_CONFIG_TYPE], prop_config))

func save_to_file(path):
	var file = File.new()
	var result = file.open(path, file.WRITE)
	if result != OK: return
	var data = serialize()
	file.store_line(data.to_json())
	file.close()

func load_from_file(path):
	var file = File.new()
	var result = file.open(path, file.READ)
	if result != OK: return
	var data = {}
	data.parse_json(file.get_line())
	deserialize(data)
	file.close()

func _to_json_name(value, type, config):
	if type == Constants.PERSIST_TYPE_VECTOR2:
		return var2str(value)
	elif type == Constants.PERSIST_TYPE_COORDINATES:
		return var2str([int(value.x), int(value.y)])
	elif type == Constants.PERSIST_TYPE_STRING:
		return str(value)
	elif type == Constants.PERSIST_TYPE_VARIANT:
		return value
	else:
		print("[ERR] Unsupported key type:", type)

func _to_json_value(value, type, config):
	if type == Constants.PERSIST_TYPE_DICTIONARY:
		var data = {}
		for key in value:
			var item = value[key]
			var key_val = _to_json_name(key, config[Constants.PERSIST_CONFIG_KEY_TYPE], config)
			var item_val = _to_json_value(item, config[Constants.PERSIST_CONFIG_ITEM_TYPE], config)
			data[key_val] = item_val
		return data
	elif type == Constants.PERSIST_TYPE_ARRAY:
		var data = []
		for item in value:
			var item_val = _from_json_value(item, config[Constants.PERSIST_CONFIG_ITEM_TYPE], config)
			data.append(item_val)
		return data
	elif type == Constants.PERSIST_TYPE_MODEL:
		var data = value.serialize()
		data[Constants.PERSIST_TYPE_MODEL_TYPE] = value._get_model_type()
		return data
	elif type == Constants.PERSIST_TYPE_VECTOR2:
		return [value.x, value.y]
	elif type == Constants.PERSIST_TYPE_COORDINATES:
		return [int(value.x), int(value.y)]
	elif type == Constants.PERSIST_TYPE_STRING:
		return str(value)
	elif type == Constants.PERSIST_TYPE_VARIANT:
		return value
	elif type == Constants.PERSIST_TYPE_BOOLEAN:
		return value
	else:
		print("[ERR] Unsupported value type:", type)

func _from_json_name(value, type, config):
	if type == Constants.PERSIST_TYPE_VECTOR2:
		return str2var(value)
	elif type == Constants.PERSIST_TYPE_COORDINATES:
		var data = str2var(value)
		return Vector2(data[0], data[1])
	elif type == Constants.PERSIST_TYPE_STRING:
		return str(value)
	elif type == Constants.PERSIST_TYPE_VARIANT:
		return value
	else:
		print("[ERR] Unsupported key type:", type)

func _from_json_value(value, type, config):
	if type == Constants.PERSIST_TYPE_DICTIONARY:
		var data = {}
		for key in value:
			var item = value[key]
			var key_val = _from_json_name(key, config[Constants.PERSIST_CONFIG_KEY_TYPE], config)
			var item_val = _from_json_value(item, config[Constants.PERSIST_CONFIG_ITEM_TYPE], config)
			data[key_val] = item_val
		return data
	elif type == Constants.PERSIST_TYPE_ARRAY:
		var data = []
		for item in value:
			var item_val = _from_json_value(item, config[Constants.PERSIST_CONFIG_ITEM_TYPE], config)
			data.append(item_val)
		return data
	elif type == Constants.PERSIST_TYPE_MODEL:
		var model = _get_model_instance(value[Constants.PERSIST_TYPE_MODEL_TYPE])
		if model == null: return
		model.deserialize(value)
		return model
	elif type == Constants.PERSIST_TYPE_VECTOR2:
		return Vector2(value[0], value[1])
	elif type == Constants.PERSIST_TYPE_COORDINATES:
		return Vector2(value[0], value[1])
	elif type == Constants.PERSIST_TYPE_STRING:
		return str(value)
	elif type == Constants.PERSIST_TYPE_VARIANT:
		return value
	elif type == Constants.PERSIST_TYPE_BOOLEAN:
		return value
	else:
		print("[ERR] Unsupported value type:", type)