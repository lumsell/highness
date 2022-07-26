extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal item_selected(item_node)
signal item_used(item_node)


var list_template = preload("res://BaseActionList.tscn")

var active_index

var item_array = Array()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

#items will need to be Matrices with the same format as the inventory
func load_items(inventory):
	
	for item in inventory:
		item_array.append(item)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func build_handout_list():
	var handout_list = list_template.instance()
	for item in item_array:
		handout_list.add_action([item[0] + " (" + str(item[2]), item[1]])
		
	handout_list.connect("item_selected", self, "_on_HandoutList_item_selected")
	handout_list.connect("item_activated", self, "_on_HandoutList_item_activated")
	return handout_list

func decrement():
	if active_index != null:
		var new_quantity = item_array[active_index][2] - 1
		if new_quantity <= 0:
			item_array.remove(active_index)
		else:
			item_array[active_index][2] = new_quantity

#TODO: connect these to the BattleController and make them do things

func _on_HandoutList_item_selected(index):
	active_index = index
	print("Debug Note: from PartyInventory: " + item_array[index][0])
	
	#var item_node = load("res://" + item_array[index][1] + ".tscn").instance()
	#emit_signal("item_selected", item_node)
	
	
func _on_HandoutList_item_activated(index):
	active_index = index
	#TODO: find a way to prevent this when the inventory's being accessed by an action, like Throw
	var item_node = load("res://" + item_array[index][1] + ".tscn").instance()
	emit_signal("item_used", item_node)
	decrement()
