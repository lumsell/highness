extends Button

signal selection_made(selection_name)

var action_array = [[],[]]

var local_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_signature(new_sig):
	text = new_sig
	name = new_sig

func set_local_index(new_index):
	local_index = new_index
	
func get_local_index():
	return local_index
	
func get_action_array(row):
	return action_array[row]
	
func _on_BaseActionButton_pressed() -> void:
	emit_signal("selection_made", name)

func add_action_node(action):
	if action.get_row_limit() == 2:
		action_array[0].append([action.get_name(), action.get_id()])
		action_array[1].append([action.get_name(), action.get_id()])
	else:
		action_array[action.get_row_limit()].append([action.get_name(),action.get_id()])
