# class AbstractEntityModel
extends "../abstract_model.gd"

var type = ""
var id = ""
var name = ""
var class_file = ""

func _get_persist_config():
	return {
		"type": {
			Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_STRING,
		},
		"id": {
			Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_STRING,
		},
		"name": {
			Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_STRING,
		},
		"class_file": {
			Constants.PERSIST_CONFIG_TYPE: Constants.PERSIST_TYPE_STRING,
		}
	}
