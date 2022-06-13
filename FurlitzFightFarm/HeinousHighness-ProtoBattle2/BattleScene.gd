extends Node

# This variable stores the ID string of the Action that the player currently
# has active
# The "active" action is the action that the player has most recently selected,
# to be executed when the player selects a target

var party_actions = Array()

var player_queued_action

var active_character

func _ready() -> void:
	active_character = $cp0001
	pass # Replace with function body.

# This can be called to start a fight, once that's a thing
# @args character array party_roster contains the party members and their
# current state so that the BattleController can assemble their battle versions
# @args action array party_actions contains all the actions that any character
# could take; the function will have to sort them to the appropriate character
# will also have to add functionality for setting up the enemies, inventory,
# map, and any other special mechanics
func commence_battle(party_roster, party_actions):
	pass

# Executes the currently selected Action on the selected target
# Right now it just changes a label to show that things are actually happening
func _on_EnemyCharacter_enemy_targeted(enemy_id) -> void:
	
	if player_queued_action == null:
		print("clicked on: " + enemy_id)
	else:
		print("targeted: " + enemy_id + " with: " + player_queued_action.get_name())
		get_node("Announcer").set_text(player_queued_action.get_name() + " : " + enemy_id)
		
		active_character.perform_action(player_queued_action)
		get_node(enemy_id).apply_action(player_queued_action)
		
		player_queued_action = null

# Recieves the active_action signal from a character and changes the current
# selection
func _on_Sprite_active_action(action) -> void:
	player_queued_action = action

