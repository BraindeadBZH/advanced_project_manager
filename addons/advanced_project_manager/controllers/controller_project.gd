# class ProjectController
extends "abstract_controller.gd"

class Constants extends "../constants.gd": func _init(): pass
class CategoryController extends "controller_category.gd": func _init(category).(category): pass

signal project_saved()
signal project_loaded()

var _project

func _init(project):
	_project = project

static func has_project():
	var file = File.new()
	var result = file.open(Constants.ROOT_PATH % Constants.PROJECT_CONFIG , File.READ)
	return result == OK 

func save_to_disk():
	_project.save_to_file(Constants.ROOT_PATH % Constants.PROJECT_CONFIG)
	emit_signal("project_saved")

func load_from_disk():
	_project.clear()
	_project.load_from_file(Constants.ROOT_PATH % Constants.PROJECT_CONFIG)
	emit_signal("project_loaded")

func set_project_type(type):
	_project.type = type
	
func get_root_category():
	return _project.root_category

func get_category_from_path(path):
	var split = path.split("/", false)
	if split.size() == 0:
		return get_root_category()
	var category = get_root_category()
	for name in split:
		var ctrl = CategoryController.new(category)
		if ctrl.has_category(name):
			category = ctrl.get_category(name)
		else:
			return null
	return category
