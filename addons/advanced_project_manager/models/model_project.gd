# class ProjectModel
extends "abstract_model.gd"

class CategoryEntityModel extends "entities/model_entity_category.gd": func _init(): pass

var type = ""
var root_category

func _init():
	_init_root_category()

func cleart():
	type = ""
	_init_root_category()

func _get_model_type():
	return "ProjectModel"

func _get_persist_config():
	return {
		"type": {
			Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_STRING,
		},
		"root_category": {
			Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_MODEL
		}
	}

func _get_model_instance(model_type):
	if model_type == "CategoryEntityModel":
		return CategoryEntityModel.new()
	return null

func _init_root_category():
	root_category = CategoryEntityModel.new()
	root_category.id = "project"
	root_category.name = "Project"
	root_category.is_static = true
