extends Node

class Constants extends "constants.gd": func _init(): pass

signal error_message(msg)
signal project_loaded()

var _templates = {}
var _project = {}

func _init():
	_load_templates()

func has_project():
	var file = File.new()
	var result = file.open(Constants.ROOT_PATH % Constants.PROJECT_CONFIG , File.READ)
	return result == OK

func init_project():
	_load_project()

func get_templates():
	return _templates

func create_project(tpl_id):
	print("[DEBUG] Create template: %s" % tpl_id)
	
	if !_templates.has(tpl_id):
		emit_signal("error_message", "Invalid template ID: %s" % tpl_id)
		return
	var template = _templates[tpl_id]
	var template_folder = Constants.ADDON_PATH % Constants.TEMPLATES_FOLDER % template.folder
	print("[DEBUG] Template folder: %s" % template_folder)
	
	var dir = Directory.new()
	var result = dir.copy("%s/%s" % [template_folder, Constants.PROJECT_CONFIG], Constants.ROOT_PATH % Constants.PROJECT_CONFIG)
	if result != OK:
		emit_signal("error_message", "Cannot create project config file: %d" % result)
		return
	_load_project()

func get_project_categories():
	return _project.categories

func _load_templates():
	var file = File.new()
	var result = file.open(Constants.ADDON_PATH % Constants.TEMPLATES_FOLDER % Constants.TEMPLATES_CONFIG , File.READ)
	if result != OK:
		emit_signal("error_message", "Cannot open templates config file: %d" % result)
		file.close()
		return
	result = _templates.parse_json(file.get_as_text())
	if result != OK:
		emit_signal("error_message", "Cannot read templates config file: %d" % result)
		file.close()
		return
	file.close()

func _load_project():
	var file = File.new()
	var result = file.open(Constants.ROOT_PATH % Constants.PROJECT_CONFIG , File.READ)
	if result != OK:
		emit_signal("error_message", "Cannot open project config file: %d" % result)
		file.close()
		return
	result = _project.parse_json(file.get_as_text())
	if result != OK:
		emit_signal("error_message", "Cannot read project config file: %d" % result)
		file.close()
		return
	file.close()
	emit_signal("project_loaded")
	
