extends Sprite

#testest
# BaseActionList is the generic scene used to generate action lists

# Sent to the BattleController to tell it the ID of the player's currently
# selected action
signal active_action(action_id)
signal character_targeted(character_id)
signal character_dead(character_id)
signal move_party(move_pattern, origin_row, origin_line)

var current_row
var current_line

#positions
var back_top = Vector2(1, 1)
var back_mid = Vector2(1, 2.75)
var back_low = Vector2(1, 4.5)

var front_top = Vector2(2, 1)
var front_mid = Vector2(2, 2.75)
var front_low = Vector2(2, 4.5)

var positions = [[back_top, back_mid, back_low],[front_top, front_mid, front_low]]

#maybe don't use these might be bad
var action_options
var active_action
#var formation_arrow = preload("res://PositionArrow.tscn")

# These arrays are used to generate the character's ActionMenu
# ATM they're stand-ins that don't actually mean anything and this whole system
# will likely be changed when actual Action nodes are added

# this String array is used to generate all the ActionButtons - not yet though,
# will need to be updated
var action_category_array = ["Attack", "Defend", "Magic", "Skill"]
# these String arrays are used to generate ActionLists for each ActionButton
# old, will remove later

var available_actions = ["aa0001", "ad0001", "am0001"]

var health = 15
var ap = 15
var strength = 3

var character_id
var alive

# Generates and shows the active character's action menu
func _ready() -> void:
	
	alive = true
	
	current_row = 0
	current_line = 0
	
	$StatBlock.build(health, ap, strength)
	
	build_combat_menu(action_category_array, available_actions)
	$CombatMenu.hide()
	
#temporary, should be replaced by a fuller build_character function later
func set_id(new_id):
	name = new_id
	character_id = new_id

func build_combat_menu(action_categories, total_action_list):
	
	$CombatMenu.add_action_buttons(action_categories)
	
	for action in total_action_list: 
		var action_node = load("res://" + action + ".tscn").instance()
		$CombatMenu.add_action(action_node)
		print("added " + action)
		action_node.queue_free()

# I think this is an old tester function that doesn't do anything anymore but
# I'm scared to delete it
func set_available_actions(action_set):
	for action in action_set:
		print("adding action")
		$CombatMenu.add_action_button(action)
		
func link_inventory(shared_inventory):
	$StatBlock.inventory_pointer = shared_inventory

# Hides the character's CombatMenu when its turn ends
# Not used yet, will be important when turns are actually ended
func end_turn():
	clear_action()
	$CombatMenu.clear_selection()
	$CombatMenu.hide()

func start_turn():
	$CombatMenu.show()

func reposition(row_num, line_num):
	#using an int as a switch makes changing simple by modular arithmetic,
	#but type might confuse something later? idk, be careful how the var is used
	print("Repositioning: " + character_id)
	
	print ("x: " + str(get_viewport_rect().size.x) + ", y: " + str(get_viewport_rect().size.y) )
	var res_modifier = Vector2(get_viewport_rect().size.x/10, get_viewport_rect().size.y/6)
	set_position(positions[row_num][line_num] * res_modifier)
	
	current_row = row_num
	current_line = line_num
	$CombatMenu.clear_selection()
	$CombatMenu.reconfigure(current_row)

# Recieves the CombatMenu's "action_selected" signal and forwards it to the
# BattleController
# This might be an unnecessary step
# It's useful for now because atm, CombatMenus are generated individually by
# the characters, but this might change depending on how we handle Action Nodes
func _on_CombatMenu_action_selected(action):

	clear_action()
	
	active_action = action
	add_child(action)
	active_action.connect("action_ready", self, "_on_ActiveAction_action_ready")
	
	action.create_options($StatBlock)
	action.position.x = get_rect().size.x * 1.3

func _on_ActiveAction_action_ready():
	emit_signal("active_action", active_action)

func apply_action(action):
	action.execute($StatBlock)

func perform_action():
	active_action.perform($StatBlock)
	$CombatMenu.clear_selection()

func clear_action():
	if active_action != null:
		remove_child(active_action)
		active_action.queue_free()
		active_action = null

func _on_StatBlock_die() -> void:
	
	#TODO emit a signal telling the BattleController to remove you
	
	alive = false
	$StatDisplay.hide()
	emit_signal("character_dead", character_id)
	set_rotation(PI/2)

#Emits the character_targeted signal to tell the BattleController that this character is now
#an active target of the player
func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("click")
		emit_signal("character_targeted", character_id)

#Gets an array of arrow sprites that represent the available reformation options
#The arrows in the array are added as children to display, then removed when one is picked

#it might be possible to make this more general, to use for other actions with options
func _on_CombatMenu_reformat(format_action) -> void:
	clear_action()
	
	active_action = format_action
	active_action.create_options(current_row, current_line)
	add_child(active_action)

	active_action.connect("action_ready", self, "_on_FormatAction_action_ready")
	
#Emits the move_party signal to the BattleController after all the choices are made
func _on_FormatAction_action_ready():
	emit_signal("move_party", active_action)

func _on_CombatMenu_button_pressed(button_name) -> void:
	clear_action()
	#TODO maybe if i feel like it; make it close if clicked twice in a row, for consistency
	#though this entire setup might be needlessly complicated, see how it goes later
	if button_name == "Item":
		active_action = Node2D.new()
		var list_container = Container.new()
		list_container.add_child($StatBlock.inventory_pointer.build_handout_list())
		active_action.add_child(list_container)
		active_action.position.x = get_rect().size.x * .76
		active_action.position.y = $CombatMenu.get_rect().position.y
		add_child(active_action)
