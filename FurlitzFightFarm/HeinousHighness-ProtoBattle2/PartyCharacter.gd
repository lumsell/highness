extends Sprite

#testest
# BaseActionList is the generic scene used to generate action lists
var ability_list_base = preload("res://BaseActionList.tscn")

# Sent to the BattleController to tell it the ID of the player's currently
# selected action
signal active_action(action_id)

# These arrays are used to generate the character's ActionMenu
# ATM they're stand-ins that don't actually mean anything and this whole system
# will likely be changed when actual Action nodes are added

# this String array is used to generate all the ActionButtons
var available_actions = ["Attack", "Defend", "Magic"]
# these String arrays are used to generate ActionLists for each ActionButton
var attack_array = ["Slap", "Punch", "Insult"]
var defend_array = ["Block", "Duck", "Beg"]
var magic_array = ["Abracadabra", "Skiddadle skidoodle", "zoot suit"]

# Generates and shows the active character's action menu
func _ready() -> void:
	$CombatMenu.add_action_button("Attack", attack_array)
	$CombatMenu.add_action_button("Defend", defend_array)
	$CombatMenu.add_action_button("Magic", magic_array)
	$CombatMenu.show()

# I think this is an old tester function that doesn't do anything anymore but
# I'm scared to delete it
func set_available_actions(action_set):
	for action in action_set:
		print("adding action")
		$CombatMenu.add_action_button(action)

# Hides the character's CombatMenu when its turn ends
# Not used yet, will be important when turns are actually ended
func end_turn():
	$CombatMenu.hide()

# Recieves the CombatMenu's "action_selected" signal and forwards it to the
# BattleController
# This might be an unnecessary step
# It's useful for now because atm, CombatMenus are generated individually by
# the characters, but this might change depending on how we handle Action Nodes
func _on_CombatMenu_action_selected(action_name) -> void:
	emit_signal("active_action", action_name)
