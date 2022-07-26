extends ItemList



var id_list = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "ActionList"

func reset_actions(action_array):
	clear()
	id_list = []
	for action in action_array:
		add_action(action)

func add_action(action):
	add_item(action[0])
	id_list.append(action[1])

func get_id_at(index):
	var item_id = id_list[index]
	return item_id

func add_node(action):
	add_item(action.get_name())
	id_list.append(action.get_id())
