tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/advanced_project_manager/views/dock/view_dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
