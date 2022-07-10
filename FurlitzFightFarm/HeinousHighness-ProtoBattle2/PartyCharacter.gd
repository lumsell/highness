extends Sprite

#testest
# BaseActionList is the generic scene used to generate action lists

# Sent to the BattleController to tell it the ID of the player's currently
# selected action
signal active_action(action_id)
signal invalid_action(reason)
signal open_inventory()
signal character_targeted(character_id)
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
var formation_arrows
var active_action
#var formation_arrow = preload("res://PositionArrow.tscn")

# These arrays are used to generate the character's ActionMenu
# ATM they're stand-ins that don't actually mean anything and this whole system
# will likely be changed when actual Action nodes are added

# this String array is used to generate all the ActionButtons - not yet though,
# will need to be updated
var action_categories = ["Attack", "Defend", "Magic", "Skill"]
# these String arrays are used to generate ActionLists for each ActionButton
# old, will remove later
var attack_array = ["Slap", "Punch", "Insult"]
var defend_array = ["Block", "Duck", "Beg"]
var magic_array = ["Abracadabra", "Skiddadle skidoodle", "zoot suit"]

var available_actions = ["aa0001", "ad0001", "am0001"]

var health = 15
var stamina = 15
var mana = 15
var strength = 3

var character_id

# Generates and shows the active character's action menu
func _ready() -> void:
	
	current_row = 0
	current_line = 0
	
	$StatBlock.build(health, stamina, mana, strength)
	
	build_combat_menu(action_categories, available_actions)
	$CombatMenu.show()

#temporary, should be replaced by a fuller build_character function later
func set_id(new_id):
	character_id = new_id

func build_combat_menu(action_categories, total_action_list):
	
	$CombatMenu.add_action_buttons(action_categories)
	
	for action in total_action_list:
		var action_scene = load("res://" + action + ".tscn")
		var action_node = action_scene.instance()
		self.add_child(action_node)
		$CombatMenu.add_action(action_node)
		
		print("added " + action)

# I think this is an old tester function that doesn't do anything anymore but
# I'm scared to delete it
func set_available_actions(action_set):
	for action in action_set:
		print("adding action")
		$CombatMenu.add_action_button(action)

# Hides the character's CombatMenu when its turn ends
# Not used yet, will be important when turns are actually ended
func end_turn():
	$CombatMenu.clear_selection()
	$CombatMenu.hide()

func start_turn():
	$CombatMenu.show()

#is enumerated type the best way to do this? can that go across nodes?
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
func _on_CombatMenu_action_selected(action_name):
	var results = get_node(action_name).cost_check($StatBlock)
	if(results[0]):
		emit_signal("active_action", get_node(action_name))
	else:
		emit_signal("invalid_action", "Not enough " + results[1])

func perform_action(action):
	action.perform($StatBlock)
	$CombatMenu.clear_selection()

func _on_StatBlock_die() -> void:
	hide()

#Because the inventory is shared between the party characters, it's handled by the BattleController
func _on_CombatMenu_open_inventory() -> void:
	emit_signal("open_inventory")

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
	if formation_arrows != null:
		for arrow in formation_arrows:
			remove_child(arrow)
	
	formation_arrows = format_action.create_options(current_row, current_line)
	active_action = format_action
	
	for arrow in formation_arrows:
		add_child(arrow)
		arrow.connect("direction_chosen", self, "_on_PositionArrow_direction_chosen")
	
#Emits the move_party signal to the BattleController after all the choices are made
func _on_PositionArrow_direction_chosen(target_row, target_line):
	emit_signal("move_party", active_action, target_row, target_line)
	
	for arrow in formation_arrows:
		remove_child(arrow)
	
	formation_arrows = null
