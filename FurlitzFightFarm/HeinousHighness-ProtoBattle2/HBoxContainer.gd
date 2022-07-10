extends HBoxContainer


# CombatMenu contains the buttons for the different categories of actions a
# character can make. Each button has an associated list of actions, and
# clicking the button brings up the ActionList

# Sent when the player clicks on an item in an ActionList
# returns action_name the ID of the selected action, for now just its name
signal action_selected(action_name)
signal open_inventory()
signal reformat(format_action)

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
var skill_index = 3
var inventory = -1
var formation = -2

#this is actually probably a bad way to do things? i dunno, see how it goes
#might need to add a typecheck somehwere - if typeof(button_array[x] == 2 then
# there is no button for category x
var button_array = [attack_index, defend_index, magic_index, skill_index]

var formation_array = ["ax0001", "ax0002", "ax0003"]
var formation_nodes = Array()
var formation_list #janky temp solution, used for the universal formation options

var row
# Sets up and initially hides the empty combat menu until the character fills it
func _ready() -> void:
	row = 1
	hide()

# Adds all ActionButtons that a character should have access to and creates a
# corresponding ActionList that can be displayed when the button is clicked

#condense this later
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
			"Skill":
				new_button.set_id(skill_index)
		
		var new_front_list = action_list.instance()
		var new_back_list = action_list.instance()
		new_front_list.connect("item_selected", self, "_on_ActionList_item_selected")
		new_back_list.connect("item_selected", self, "_on_ActionList_item_selected")
		#connects the button to an action list via a pointer in the button
		if new_button.get_id() >= 0:
			new_button.set_action_lists(new_front_list, new_back_list)
			button_array[new_button.get_id()] = new_button
		print(new_button.get_id())
		print(new_button.get_text())
	
	var item_button = action_button.instance()
	item_button.set_id(inventory)
	item_button.set_signature("Item")
	item_button.connect("selection_made", self, "_on_ActionButton_selection_made")
	$ActionMenu.add_child(item_button)
	var formation_button = action_button.instance()
	formation_button.set_id(formation)
	formation_button.set_signature("Formation")
	formation_button.connect("selection_made", self, "_on_ActionButton_selection_made")
	$ActionMenu.add_child(formation_button)
	
	formation_list = action_list.instance()
	for option in formation_array:
		var formation_node = load("res://" + option + ".tscn").instance()
		formation_list.add_node(formation_node)
		formation_nodes.append(formation_node)
	formation_list.connect("item_selected", self, "_on_FormationList_item_selected")
		

# Checks the second character in the id String and uses that to add
# the action to the appropriate list
func add_action(action):
	match action.get_id().substr(1,1):
		"a":
			button_array[attack_index].add_action_node(action)
		"d":
			button_array[defend_index].add_action_node(action)
		"m":
			button_array[magic_index].add_action_node(action)

#0 is the back row, 1 is the front row
func reconfigure(new_row):
	row = new_row
	for button in button_array:
		if typeof(button) != 2: #may or may not be unnecessary, depending on how
							#much the combat menu changes between characters
			if button.get_action_list(row).get_item_count() == 0:
				button.hide()
			else:
				button.show()
	
# Brings up the corresponding AbilityList when an ActionButton is pressed
func _on_ActionButton_selection_made(button_id):
	print(button_id)
	
	# if there's a list currently being displayed, its removed and its selection
	# is clread
	if current_list != null:
		$ListContainer.remove_child(current_list)
		current_list.unselect_all()
	#if the same button is clicked twice in a row, its just removed
	#if button_id == -1:
	#	emit_signal("open_inventory")
	#if button_id == -2:
	#	clear_selection()
	#	current_type = (current_type + 1) % 2
	if button_id < 0:
		if button_id == inventory:
			emit_signal("open_inventory")
		elif button_id == formation:
			#reconfigure((row + 1) % 2)
			current_list = formation_list
			$ListContainer.add_child(current_list)

	elif current_list == button_array[button_id].get_action_list(row):
		current_list = null
	else:
		current_list = button_array[button_id].get_action_list(row)
		$ListContainer.add_child(current_list)
	
func clear_selection():
	if current_list != null:
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

func _on_FormationList_item_selected(index):
	var formation_action = formation_nodes[index]
	print("From formation list, selected: " + formation_action.get_id())
	#should probably add an option to confirm the reformat
	emit_signal("reformat", formation_action)

func _on_StatBlock_health_changed(new_health) -> void:
	pass # Replace with function body.
