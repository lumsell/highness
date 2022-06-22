extends Sprite

#testest
# BaseActionList is the generic scene used to generate action lists

# Sent to the BattleController to tell it the ID of the player's currently
# selected action
signal active_action(action_id)
signal invalid_action(reason)
signal open_inventory()
signal character_targeted(character_id)

# These arrays are used to generate the character's ActionMenu
# ATM they're stand-ins that don't actually mean anything and this whole system
# will likely be changed when actual Action nodes are added

# this String array is used to generate all the ActionButtons - not yet though,
# will need to be updated
var action_categories = ["Attack", "Defend", "Magic", "Use Item"]
# these String arrays are used to generate ActionLists for each ActionButton
# old, will remove later
var attack_array = ["Slap", "Punch", "Insult"]
var defend_array = ["Block", "Duck", "Beg"]
var magic_array = ["Abracadabra", "Skiddadle skidoodle", "zoot suit"]

var available_actions = ["as0001", "ad0001", "am0001"]

var health = 15
var stamina = 15
var mana = 15
var strength = 3

var character_id

# Generates and shows the active character's action menu
func _ready() -> void:
	character_id = "cp0001"
	
	$StatBlock.build(health, stamina, mana, strength)
	
	build_combat_menu(action_categories, available_actions)
	$CombatMenu.show()

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


func _on_CombatMenu_open_inventory() -> void:
	emit_signal("open_inventory")


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("click")
		emit_signal("character_targeted", character_id)
