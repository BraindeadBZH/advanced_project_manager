tool
# class DockView
extends "../abstract_view.gd"

class Constants extends "../../constants.gd": func _init(): pass
class ProjectController extends "../../controllers/controller_project.gd": func _init(project).(project): pass
class TemplateController extends "../../controllers/controller_template.gd": func _init(project_ctrl).(project_ctrl): pass
class ProjectModel extends "../../models/model_project.gd": func _init(): pass

const BTN_CATEGORY_ADD    = 100
const BTN_PROJECT_CONFIG  = BTN_CATEGORY_ADD+1
const BTN_CATEGORY_CONFIG = BTN_PROJECT_CONFIG+1
const BTN_FILE_OPEN       = BTN_CATEGORY_CONFIG+1

onready var dlg_error        = get_node("dlg_error")

onready var pnl_templates    = get_node("pnl_templates")
onready var opt_project_type = get_node("pnl_templates/grid_main/opt_project_type")

onready var pnl_project      = get_node("pnl_project")
onready var tree_project     = get_node("pnl_project/tree_project")

var project_type_index = []
var project = ProjectModel.new()
var project_ctrl = ProjectController.new(project)
var template_ctrl = TemplateController.new(project_ctrl)

func _init():
	project_ctrl.connect("log_message", self, "_on_log_message")
	project_ctrl.connect("project_loaded", self, "_on_project_loaded")
	template_ctrl.connect("project_created", self, "_on_project_created")

func _ready():
	_check_for_project()

func _check_for_project():
	if !ProjectController.has_project():
		_show_templates()
	else:
		project_ctrl.load_from_disk()

func _show_templates():
	pnl_project.set_hidden(true)
	pnl_templates.set_hidden(false)
	if opt_project_type.get_item_count() > 0: opt_project_type.clear()
	var templates = template_ctrl.get_templates()
	if templates == null: return
	for id in templates:
		opt_project_type.add_item(templates[id].name, project_type_index.size())
		project_type_index.append(id)

func _show_project():
	pnl_templates.set_hidden(true)
	pnl_project.set_hidden(false)
	if tree_project.get_root() != null: tree_project.clear()
	tree_project.set_columns(1)
	var root_category = project_ctrl.get_root_category()
	var root = tree_project.create_item()
	root.set_icon(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_categ.tres"))
	root.set_text(0, root_category.name)
	root.add_button(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_tools.tres"), BTN_PROJECT_CONFIG)
	for id in root_category.structure:
		_add_entity(root_category.structure[id], root)

func _add_entity(entity, parent):
	var item = tree_project.create_item(parent)
	item.set_text(0, entity.name)
	item.set_collapsed(true)
	if entity.type == Constants.ENTITY_TYPE_CATEGORY:
		item.set_icon(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_categ.tres"))
		item.add_button(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_add.tres"), BTN_CATEGORY_ADD)
		item.add_button(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_tools.tres"), BTN_CATEGORY_CONFIG)
		var class_item = tree_project.create_item(item)
		class_item.set_text(0, entity.class_file)
		class_item.set_icon(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_file.tres"))
		class_item.add_button(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_open.tres"), BTN_FILE_OPEN)
		for id in entity.structure:
			_add_entity(entity.structure[id], item)
		
	elif entity.type == Constants.ENTITY_TYPE_CLASS:
		item.set_icon(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_class.tres"))
		var class_item = tree_project.create_item(item)
		class_item.set_text(0, entity.class_file)
		class_item.set_icon(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_file.tres"))
		class_item.add_button(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_open.tres"), BTN_FILE_OPEN)
		if entity.has_scene:
			var scene_item = tree_project.create_item(item)
			scene_item.set_text(0, entity.scene_file)
			scene_item.set_icon(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_file.tres"))
			scene_item.add_button(0, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_open.tres"), BTN_FILE_OPEN)

func _on_log_message(type, msg):
	var fmt = "[%s] %s"
	if type == Constants.MESSAGE_TYPE_DEBUG:
		print(fmt % ["DEBUG", msg])
	elif type == Constants.MESSAGE_TYPE_INFO:
		print(fmt % ["INFO", msg])
	elif type == Constants.MESSAGE_TYPE_WARNING:
		print(fmt % ["WARNING", msg])
	elif type == Constants.MESSAGE_TYPE_ERROR:
		print(fmt % ["ERROR", msg])
		dlg_error.set_text("Error! %s" % msg)
		dlg_error.popup_centered_minsize()

func _on_project_loaded():
	_show_project()

func _on_project_created():
	_show_project()

func _on_btn_create_pressed():
	template_ctrl.create_project(project_type_index[opt_project_type.get_selected_ID()])
