# class CategoryEntityModel
extends "abstract_model_entity.gd"

class ClassEntityModel extends "model_entity_class.gd": func _init(): pass

var structure = {}
var is_static = false

func _init():
	type = Constants.ENTITY_TYPE_CATEGORY

func _get_model_type():
	return "CategoryEntityModel"

func _get_persist_config():
	var config = ._get_persist_config()
	config["structure"] = {
		Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_DICTIONARY,
		Constants.PERSIST_CONFIG_KEY_TYPE: Constants.PERSIST_TYPE_STRING,
		Constants.PERSIST_CONFIG_ITEM_TYPE: Constants.PERSIST_TYPE_MODEL
	}
	config["is_static"] = {
		Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_BOOLEAN
	}
	return config

func _get_model_instance(model_type):
	if model_type == "CategoryEntityModel":
		return get_script().new()
	elif model_type == "ClassEntityModel":
		return ClassEntityModel.new()
	return null
