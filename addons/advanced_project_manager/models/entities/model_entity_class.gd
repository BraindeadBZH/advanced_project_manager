# class ClassEntityModel
extends "abstract_model_entity.gd"

var has_scene = false
var scene_file = ""

func _init():
	type = Constants.ENTITY_TYPE_CLASS

func _get_model_type():
	return "ClassEntityModel"

func _get_persist_config():
	var config = ._get_persist_config()
	config["has_scene"] = {
		Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_BOOLEAN
	}
	config["scene_file"] = {
		Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_STRING
	}
	return config
