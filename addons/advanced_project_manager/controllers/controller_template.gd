# class TemplateController
extends "abstract_controller.gd"

class Constants extends "../constants.gd": func _init(): pass
class CategoryController extends "controller_category.gd": func _init(category).(category): pass

signal project_created()

var _project_ctrl
var _templates = {}
var _template_cfg = {}

func _init(project_ctrl):
	_project_ctrl = project_ctrl
	_load_templates()

func get_templates():
	return _templates

func create_project(tpl_id):
	log_info("Creating from template: %s" % tpl_id)
	if _project_ctrl.has_project():
		log_error("Project already created")
		return
	if !_templates.has(tpl_id):
		log_error("Invalid template ID: %s" % tpl_id)
		return
	_project_ctrl.set_project_type(tpl_id)
	_read_template_config(tpl_id)
	_create_categories()
	_create_classes()
	emit_signal("project_created")

func _load_templates():
	var file = File.new()
	var result = file.open(Constants.ADDON_PATH % Constants.TEMPLATES_FOLDER % Constants.TEMPLATES_CONFIG , File.READ)
	if result != OK:
		log_error("Cannot open templates config file: %d" % result)
		file.close()
		return
	result = _templates.parse_json(file.get_as_text())
	if result != OK:
		log_error("Cannot read templates config file: %d" % result)
		file.close()
		return
	file.close()

func _read_template_config(tpl_id):
	var template = _templates[tpl_id]
	var template_folder = Constants.ADDON_PATH % Constants.TEMPLATES_FOLDER % tpl_id
	log_info("Template folder: %s" % template_folder)
	var file = File.new()
	var result = file.open("%s/%s" % [template_folder, Constants.TEMPLATE_CONFIG], File.READ)
	if result != OK:
		log_error("Cannot open template config file: %d" % result)
		return
	_template_cfg.clear()
	result = _template_cfg.parse_json(file.get_as_text())
	if result != OK:
		log_error("Cannot read template config file: %d" % result)
		return

func _create_classes():
	if !_template_cfg.has(Constants.TPL_SECTION_CLASSES):
		log_error("Template does not contain the '%s' section" % Constants.TPL_SECTION_CLASSES)
		return
	var config = _template_cfg[Constants.TPL_SECTION_CLASSES]
	for id in config:
		var class_config = config[id]
		_create_class(_project_ctrl.get_category_from_path(class_config.category), id, class_config)
	_project_ctrl.save_to_disk()

func _create_categories():
	if !_template_cfg.has(Constants.TPL_SECTION_CATEGORIES):
		log_error("Template does not contain the '%s' section" % Constants.TPL_SECTION_CATEGORIES)
		return
	var config = _template_cfg[Constants.TPL_SECTION_CATEGORIES]
	for id in config:
		_create_category(_project_ctrl.get_root_category(), id, config[id])
	_project_ctrl.save_to_disk()

func _create_class(category, id, config):
	if category == null:
		log_error("Cannot add class '%s' to null category" % id)
		return
	var ctrl = CategoryController.new(category)
	ctrl.add_class(id, config.name, config.class_file, config.scene)

func _create_category(category, id, config):
	var ctrl = CategoryController.new(category)
	var created_category = ctrl.add_category(id, config.name, config.class_file, true)
	if config.has(Constants.TPL_SECTION_CATEGORIES):
		var sub_config = config[Constants.TPL_SECTION_CATEGORIES]
		for sub_id in sub_config:
			_create_category(created_category, sub_id, sub_config[sub_id])
