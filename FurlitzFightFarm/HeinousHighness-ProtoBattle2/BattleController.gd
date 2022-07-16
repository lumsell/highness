extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var p_char_template = preload("res://PartyCharacter.tscn")
var e_char_template = preload("res://EnemyCharacter.tscn")

var party = ["cp0001", "cp0002", "cp0003"]
var enemies = ["ce0001", "ce0002", "ce0003"]

var frodo_image = preload("res://ArtAssets/frodo_static.png")
var aristotle_image = preload("res://ArtAssets/aristotle_static.png")



var active_character
var active_action
var active_target

var front_row
var back_row
var party_formation = [back_row, front_row]

var back_top
var back_mid
var back_low

var front_top
var front_mid
var front_low

var positions = [[back_top, back_mid, back_low], [front_top, front_mid, front_low]] #
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	var k = 0
	while i < 10:
		k = (k + 1) % 2
		print(k)
		i += 1
	build_battle(party, enemies)
	get_tree().get_root().connect("size_changed", self, "resize_position()")

#func _process(delta):
#	front_mid.x = 13

#maybe won't ever use this, just thinking about resolution changes and junk
func resize_position():
	pass


func build_battle(party_list, enemy_list):
	var i = 0
	var j = 0
	for character_id in party_list:
		#var character = load("res://" + character_id + ".tscn")
		var new_puppet = p_char_template.instance()
		new_puppet.set_global_scale(Vector2(.2,.2))
		add_child(new_puppet, true)
		new_puppet.name = character_id #allows the puppet to be accessed by id
		new_puppet.set_id(character_id)
		print(get_node(character_id).name) #for testing
		
		new_puppet.reposition(j, i)
		new_puppet.connect("move_party", self, "_on_Character_move_party")
		new_puppet.connect("active_action", self, "_on_Character_active_action")
		
		positions[j][i] = new_puppet
		
		if i == 1:
			new_puppet.set_texture(frodo_image)
			active_character = new_puppet
		if i == 2:
			new_puppet.set_texture(aristotle_image)
		print("Position array size: " + str(positions[j].size()))
		i += 1
		j = (j + 1) % 2
		
	
	i = 0
	for character_id in enemy_list:
		var new_puppet = e_char_template.instance()
		new_puppet.set_global_scale(Vector2(.2,.2))
		add_child(new_puppet, true)
		
		new_puppet.connect("enemy_targeted", self, "_on_Character_character_targeted")
		
		#this might become a problem later, if enemies of same type are in same battle with same ID
		new_puppet.name = character_id
		new_puppet.set_id(character_id)
		new_puppet.reposition(1, i)
		i += 1
		#new_puppet.set_texture

func next_turn():
	active_character.end_turn()
	active_action = null
	active_target = null
	

func _on_Character_active_action(action):
	active_action = action
		
func _on_Character_character_targeted(target_id):
	active_target = get_node(target_id)
	if active_action == null:
		print("Targeted " + target_id)
	else:
		active_character.perform_action(active_action)
		active_target.apply_action(active_action)
		next_turn()
#Changes the party's formation when a movement action is selected
#The Formation is tracked with the 2D array positions. The positions matrix
	#can be passed to the movement_action's execute function, which will generate
	#new positions to represent the movement
func _on_Character_move_party(movement_action, target_row, target_line):
	#The execute function needs to know the target row and line, which comes from
		#the option arrow that the player chooses. The origin row and line are also
		#required, but the movement node saves them when generating the option arrows
	positions = movement_action.execute(positions, target_row, target_line)
	#remember to enable this line once the active character is a thing
	#active_character.perform_action(movement_action)
	
	for i in 2:
		for n in 3:
			if positions[i][n] != null:
				positions[i][n].reposition(i, n)
	
	
