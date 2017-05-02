# class CategoryController
extends "abstract_controller.gd"

class ClassEntityModel extends "../models/entities/model_entity_class.gd": func _init(): pass
class CategoryEntityModel extends "../models/entities/model_entity_category.gd": func _init(): pass

var _category

func _init(category):
	_category = category

func add_class(id, name, class_file, scene_file = ""):
	var class_entity = ClassEntityModel.new()
	class_entity.id = id
	class_entity.name = name
	class_entity.class_file = class_file
	if scene_file == "":
		class_entity.has_scene = false
	else:
		class_entity.has_scene = true
	class_entity.scene_file = scene_file
	_add_entity(class_entity)
	return class_entity

func add_category(id, name, class_file, is_static = false):
	var categ_entity = CategoryEntityModel.new()
	categ_entity.id = id
	categ_entity.name = name
	categ_entity.class_file = class_file
	categ_entity.is_static = is_static
	_add_entity(categ_entity)
	return categ_entity

func has_category(id):
	if _category.structure.has(id):
		var entity = _category.structure[id]
		if entity.type == Constants.ENTITY_TYPE_CATEGORY:
			return true
		else:
			return false
	else:
		return false

func get_category(id):
	if has_category(id):
		return _category.structure[id]
	else:
		return null

func _add_entity(entity):
	if _category.structure.has(entity.id):
		log_warning("Could not add class to category '%s' because '%s' already exists" % [_category.id, entity.id])
		return
	_category.structure[entity.id] = entity
