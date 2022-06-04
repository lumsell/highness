extends Node

# This variable stores the ID string of the Action that the player currently
# has active
# The "active" action is the action that the player has most recently selected,
# to be executed when the player selects a target
var player_queued_action

func _ready() -> void:
	pass # Replace with function body.

# Executes the currently selected Action on the selected target
# Right now it just changes a label to show that things are actually happening
func _on_EnemyCharacter_enemy_targeted(enemy_id) -> void:
	if player_queued_action == null:
		print("clicked on: " + enemy_id)
	else:
		print("targeted: " + enemy_id + " with: " + player_queued_action)
		get_node("Announcer").set_text(player_queued_action + " : " + enemy_id)
		player_queued_action = null

# Recieves the active_action signal from a character and changes the current
# selection
func _on_Sprite_active_action(action_id) -> void:
	player_queued_action = action_id
