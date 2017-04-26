tool
extends Control

class Constants extends "constants.gd": func _init(): pass
class ProjectManager extends "project_manager.gd": func _init(): pass

const BTN_CATEGORY_ADD    = 100
const BTN_PROJECT_CONFIG  = BTN_CATEGORY_ADD+1
const BTN_CATEGORY_CONFIG = BTN_PROJECT_CONFIG+1

onready var dlg_error        = get_node("dlg_error")

onready var pnl_templates    = get_node("pnl_templates")
onready var opt_project_type = get_node("pnl_templates/grid_main/opt_project_type")

onready var pnl_project      = get_node("pnl_project")
onready var tree_project     = get_node("pnl_project/tree_project")

var project_type_index = []
var prj_manager = ProjectManager.new()

func _init():
	prj_manager.connect("error_message", self, "_on_error_message")
	prj_manager.connect("project_loaded", self, "_on_project_loaded")

func _ready():
	_check_for_project()

func _check_for_project():
	if !prj_manager.has_project():
		_show_templates()
	else:
		prj_manager.init_project()

func _show_templates():
	pnl_project.set_hidden(true)
	pnl_templates.set_hidden(false)
	if opt_project_type.get_item_count() > 0: opt_project_type.clear()
	var templates = prj_manager.get_templates()
	if templates == null: return
	for id in templates:
		print("[DEBUG] Loading template: ", id)
		opt_project_type.add_item(templates[id].name, project_type_index.size())
		project_type_index.append(id)

func _show_project():
	pnl_templates.set_hidden(true)
	pnl_project.set_hidden(false)
	if tree_project.get_root() != null: tree_project.clear()
	tree_project.set_columns(2)
	var root = tree_project.create_item()
	root.set_text(0, "Project")
	root.add_button(1, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_tools.tres"), BTN_PROJECT_CONFIG)
	var categories = prj_manager.get_project_categories()
	for id in categories:
		_add_category(categories[id], root)

func _add_category(categ, parent):
	var item = tree_project.create_item(parent)
	item.set_text(0, categ.name)
	item.add_button(1, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_add.tres"), BTN_CATEGORY_ADD)
	item.add_button(1, load(Constants.ADDON_PATH % Constants.RESOURCES_FOLDER % "icon_tools.tres"), BTN_CATEGORY_CONFIG)
	if categ.has("categories"):
		for id in categ.categories:
			_add_category(categ.categories[id], item)

func _on_error_message(msg):
	print("[ERROR] %s" % msg)
	dlg_error.set_text("Error! %s" % msg)
	dlg_error.popup_centered_minsize()
	
func _on_project_loaded():
	_show_project()

func _on_btn_create_pressed():
	prj_manager.create_project(project_type_index[opt_project_type.get_selected_ID()])
