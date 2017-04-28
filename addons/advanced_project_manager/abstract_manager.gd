extends Node

class Constants extends "constants.gd": func _init(): pass

signal log_message(type, msg)

func log_debug(msg):
	emit_signal("log_message", Constants.MESSAGE_TYPE_DEBUG, msg)

func log_info(msg):
	emit_signal("log_message", Constants.MESSAGE_TYPE_INFO, msg)

func log_warning(msg):
	emit_signal("log_message", Constants.MESSAGE_TYPE_WARNING, msg)

func log_error(msg):
	emit_signal("log_message", Constants.MESSAGE_TYPE_ERROR, msg)
