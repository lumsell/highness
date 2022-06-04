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
var ability_list = preload("res://BaseActionList.tscn")

var current_list

# num_buttons is a counter, given to a button as its ID when it's added to the
# menu in order to match the button to an index in the array list_array where 
# the button's corresponding ActionList is stored

# this is kind of a messy solution and is supposed to be temporary
var num_buttons

# list_array stores ActionLists at indexes that correspond to Button IDs
var list_array=[]

# Sets up and initially hides the empty combat menu until the character fills it
func _ready() -> void:
	num_buttons = 0
	hide()

# Makes and adds a new ActionButton and its corresponding ActionList
# @args action_sig the ID signature of an action, for now just used as its name
# @args ability_array the array containing all the actions of the button's
# category
func add_action_button(action_sig, ability_array):
	var new_button = action_button.instance()
	var test = "selection_made"
	new_button.set_signature(action_sig)
	new_button.set_id(num_buttons)
	new_button.connect("selection_made", self, "_on_ActionButton_" + test)
	$ActionMenu.add_child(new_button)
	
	#the newly created list is stored in an array at an index that should
	#match the int value of the id variable stored in the new button
	var new_list = ability_list.instance()
	new_list.load_items(ability_array)
	new_list.connect("item_selected", self, "_on_ActionList_item_selected")
	
	list_array.append([])
	list_array[num_buttons] = new_list
	
	num_buttons += 1

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
	
# Sends the "action_selected" signal when the player clicks on an item from an
# ActionList
func _on_ActionList_item_selected(index):
	var selected_ability = current_list.get_item_text(index)
	selected_ability = selected_ability
	print("From Combat Menu: " + selected_ability)
	emit_signal("action_selected", selected_ability)
