extends Button

var action_lists = [0, 1]

signal selection_made(selection_sig)

var signature
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_signature(new_sig):
	signature = new_sig
	text = signature

func set_id(new_id):
	id = new_id
	
func get_id():
	var ret_val
	ret_val = id
	return ret_val
	
func _on_BaseActionButton_pressed() -> void:
	emit_signal("selection_made", id)

func set_action_lists(new_front_list, new_back_list):
	action_lists[0] = new_back_list
	action_lists[1] = new_front_list

func get_action_list(row):
	return action_lists[row]

func add_action_node(action):
	if action.get_row_limit() == 2:
		action_lists[0].add_node(action)
		action_lists[1].add_node(action)
	else:
		action_lists[action.get_row_limit()].add_node(action)
