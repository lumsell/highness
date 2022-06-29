extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var p_char_template = preload("res://PartyCharacter.tscn")

var party = ["cp0001", "cp0002", "cp0003"]
var enemies = ["ce0001", "ce0002", "ce0003"]

var frodo_image = preload("res://ArtAssets/frodo_static.png")
var aristotle_image = preload("res://ArtAssets/aristotle_static.png")

var active_character
var active_selection
var active_target

enum PositionCol {BACK, FRONT}
enum PositionRow {TOP, MIDDLE, BOTTOM}

var back_top = Vector2(1, 1)
var back_mid = Vector2(1, 2.75)
var back_low = Vector2(1, 4.5)

var front_top = Vector2(2, 1)
var front_mid = Vector2(2, 2.75)
var front_low = Vector2(2, 4.5)

var positions = [back_top, back_mid, back_low, front_top, front_mid, front_low] #
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


func build_battle(party_roster, enemy_roster):
	var i = 0
	for character_id in party:
		#var character = load("res://" + character_id + ".tscn")
		var new_puppet = p_char_template.instance()
		new_puppet.set_global_scale(Vector2(.2,.2))
		add_child(new_puppet, true)
		new_puppet.name = character_id #allows the puppet to be accessed by id
		new_puppet.set_position(positions[i] * (new_puppet.get_rect().size/10))
		print(get_node(character_id).name) #for testing
		if i == 1: #in the future, sprite locations should be somehow carried with characters
			new_puppet.set_texture(frodo_image)
			new_puppet.set_position(positions[4] * (new_puppet.get_rect().size/10))
		if i == 2:
			new_puppet.set_texture(aristotle_image)
		print(new_puppet.get_rect().size) #for testing
		i += 1
		
