extends Node

#Could actions be stored as children of the controller instead of the characters?
#The actions need to be modified based on the characters, that can be done with
# the "perform_action" method

# This variable stores the ID string of the Action that the player currently
# has active
# The "active" action is the action that the player has most recently selected,
# to be executed when the player selects a target

var party_actions = Array()

var player_queued_action

var active_character



func _ready() -> void:
	active_character = $cp0001
	$PartyInventory.load_items(["ic0001"])
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
		return

	match player_queued_action.get_id().substr(0,1):
		"i":
			pass
		"a":
			if player_queued_action == null:
				print("clicked on: " + enemy_id)
			else:
				print("targeted: " + enemy_id + " with: " + player_queued_action.get_name())
				get_node("Announcer").set_text(player_queued_action.get_name() + " : " + enemy_id)
		
				player_queued_action.perform(active_character.get_node("StatBlock"))

		#This will need to change, multiple enemies of the same type will have
		# the same idea - use a node array to keep track of them?
				player_queued_action.execute(get_node(enemy_id).get_node("StatBlock"))
		
	active_character.end_turn()
	player_queued_action = null
	$PartyInventory.hide()
	active_character.start_turn()
		
# Recieves the active_action signal from a character and changes the current
# selection
func _on_Sprite_active_action(action) -> void:
	player_queued_action = action
	$PartyInventory.hide()


func _on_cp0001_invalid_action(reason) -> void:
	get_node("Announcer").set_text(reason)


func _on_cp0001_open_inventory() -> void:
	$PartyInventory.show()


func _on_cp0001_character_targeted(character_id) -> void:
	print("Clicked on " + character_id)
	print(player_queued_action.get_id().substr(0,1))
	match player_queued_action.get_id().substr(0,1):
		"a":
			pass
		"i":
			player_queued_action.use(get_node(character_id).get_node("StatBlock"))
			$PartyInventory.hide()
	active_character.end_turn()
	active_character.start_turn()

func _on_PartyInventory_selection_made(selected_item) -> void:
	print("Item selected")
	print(selected_item.get_id())
	player_queued_action = selected_item
