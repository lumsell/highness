extends HBoxContainer


# CombatMenu contains the buttons for the different categories of actions a
# character can make. Each button has an associated list of actions, and
# clicking the button brings up the ActionList

# Sent when the player clicks on an item in an ActionList
# returns action_name the ID of the selected action, for now just its name
signal action_selected(action_name)
signal button_pressed(button_id)
signal reformat(format_action)

# BaseActionButton and BaseActionList are generic scene nodes with the premade
# functionality to build a unique Action Menu
var action_button = preload("res://BaseActionButton.tscn")

var action_list = load("res://BaseActionList.tscn").instance()

var current_list

var button_categories




# list_array stores ActionLists at indexes that correspond to Button IDs
# As it's set up now, the array generally be bigger than it needs to be
# because these indexes are hard-coded so that there will have to be one
# for every possible button, even if the character won't use is
var attack_index = 0
var defend_index = 1
var magic_index = 2
var skill_index = 3
var inventory = -1
var formation = 4


#this is actually probably a bad way to do things? i dunno, see how it goes
#might need to add a typecheck somehwere - if typeof(button_array[x] == 2 then
# there is no button for category x
var active_button

var formation_array = ["ax0001", "ax0002", "ax0003"]
var formation_nodes = Array()
var formation_list #janky temp solution, used for the universal formation options

var row
# Sets up and initially hides the empty combat menu until the character fills it
func _ready() -> void:
	
	row = 1
	#hide()

# Adds all ActionButtons that a character should have access to and creates a
# corresponding ActionList that can be displayed when the button is clicked

#condense this later
func add_action_buttons(category_array):
	button_categories = category_array
	
	for category in category_array:
		var new_button = action_button.instance()
		$ActionMenu.add_child(new_button)
		
		new_button.set_signature(category)
		new_button.connect("selection_made", self, "_on_ActionButton_selection_made")
		
		#connects the button to an action list via a pointer in the button
	
	var item_button = action_button.instance()
	item_button.set_signature("Item")
	item_button.connect("selection_made", self, "_on_ActionButton_selection_made")
	$ActionMenu.add_child(item_button)
	var formation_button = action_button.instance()
	formation_button.set_signature("Formation")
	formation_button.connect("selection_made", self, "_on_ActionButton_selection_made")
	$ActionMenu.add_child(formation_button)
	
	for option in formation_array:
		var formation_node = load("res://" + option + ".tscn").instance()
		$ActionMenu.get_node("Formation").add_action_node(formation_node)
		formation_node.queue_free()
		
	$ListContainer.add_child(action_list)
	action_list.connect("item_selected", self, "_on_ActionList_item_selected")
		
# Checks the second character in the id String and uses that to add
# the action to the appropriate list
func add_action(action):
	match action.get_id().substr(1,1):
		"a":
			$ActionMenu.get_node("Attack").add_action_node(action)
		"d":
			$ActionMenu.get_node("Defend").add_action_node(action)
		"m":
			$ActionMenu.get_node("Magic").add_action_node(action)

#0 is the back row, 1 is the front row
func reconfigure(new_row):
	row = new_row
	for button_name in button_categories:
		var button = $ActionMenu.get_node(button_name)
		if button.get_action_array(row).size() > 0:
			button.show()
		else:
			button.hide()
			
	
# Brings up the corresponding AbilityList when an ActionButton is pressed
func _on_ActionButton_selection_made(button_name):
	print(button_name)
	emit_signal("button_pressed", button_name)

	current_list = $ListContainer.get_node("ActionList")

	current_list.hide()
	
	if button_name == active_button:
		active_button = null
	
	elif button_name == "Item":
		pass
		#emit_signal("open_inventory")
	else:
		active_button = button_name
		current_list.reset_actions($ActionMenu.get_node(active_button).get_action_array(row))
		current_list.show()
	
func clear_selection():
	if current_list != null:
		current_list.clear()
		current_list.hide()
		active_button = null

# Sends the "action_selected" signal when the player clicks on an item from an
# ActionList
func _on_ActionList_item_selected(index):
	var selected_ability_id = current_list.get_id_at(index)
	var selected_action = load("res://" + selected_ability_id + ".tscn").instance()
	print("From Combat Menu: " + selected_action.get_id())
	
	if active_button == "Formation":
		emit_signal("reformat", selected_action)
	else:
		emit_signal("action_selected", selected_action)
