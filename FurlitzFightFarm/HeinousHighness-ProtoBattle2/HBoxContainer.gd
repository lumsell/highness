extends HBoxContainer


# CombatMenu contains the buttons for the different categories of actions a
# character can make. Each button has an associated list of actions, and
# clicking the button brings up the ActionList

# Sent when the player clicks on an item in an ActionList
# returns action_name the ID of the selected action, for now just its name
signal action_selected(action_name)

# BaseActionButton and BaseActionList are generic scene nodes with the premade
# functionality to build a unique Action Menu
var action_button = preload("res://BaseActionButton.tscn")
var action_list = preload("res://BaseActionList.tscn")

var current_list

# list_array stores ActionLists at indexes that correspond to Button IDs
# As it's set up now, the array generally be bigger than it needs to be
# because these indexes are hard-coded so that there will have to be one
# for every possible button, even if the character won't use is
var attack_index = 0
var defend_index = 1
var magic_index = 2

var list_array = [attack_index, defend_index, magic_index]

# Sets up and initially hides the empty combat menu until the character fills it
func _ready() -> void:
	hide()

# Adds all ActionButtons that a character should have access to and creates a
# corresponding ActionList that can be displayed when the button is clicked
func add_action_buttons(category_array):
	for category in category_array:
		var new_button = action_button.instance()
		new_button.set_signature(category)
		new_button.connect("selection_made", self, "_on_ActionButton_selection_made")
		$ActionMenu.add_child(new_button)
		
		# The Button ids match to the index in the array where the appropriate
		# ActionList is stored
		match category:
			"Attack":
				new_button.set_id(attack_index)
			"Defend":
				new_button.set_id(defend_index)
			"Magic":
				new_button.set_id(magic_index)
		
		var new_action_list = action_list.instance()
		new_action_list.connect("item_selected", self, "_on_ActionList_item_selected")
		#connects the button to an action list via a pointer in the button
		list_array[new_button.get_id()] = new_action_list
		print(new_button.get_id())
		print(new_button.get_text())

# Checks the second character in the id String and uses that to add
# the action to the appropriate list
func add_action(action):
	match action.get_id().substr(1,1):
		"s": # "s" stands for strike which means attack, because "a" is action
			# could be changed later, depending on which is more confusing
			list_array[attack_index].load_node(action)
		"d":
			list_array[defend_index].load_node(action)
		"m":
			list_array[magic_index].load_node(action)

# Brings up the corresponding AbilityList when an ActionButton is pressed
func _on_ActionButton_selection_made(button_id):
	print(button_id)
	# if there's a list currently being displayed, its removed and its selection
	# is clread
	if current_list != null:
		$ListContainer.remove_child(current_list)
		current_list.unselect_all()
	#if the same button is clicked twice in a row, its just removed
	if current_list == list_array[button_id]:
		current_list = null
	else:
		current_list = list_array[button_id]
		$ListContainer.add_child(current_list)
	
func clear_selection():
	$ListContainer.remove_child(current_list)
	current_list.unselect_all()
	current_list = null
	
# Sends the "action_selected" signal when the player clicks on an item from an
# ActionList
func _on_ActionList_item_selected(index):
	var selected_ability = current_list.get_id_at(index)
	selected_ability = selected_ability
	print("From Combat Menu: " + selected_ability)
	emit_signal("action_selected", selected_ability)


func _on_StatBlock_health_changed(new_health) -> void:
	pass # Replace with function body.
