extends Node


var roster_array = Array()
var next_index


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_index = 0
	pass # Replace with function body.

func add_character(new_character):
	roster_array.append(new_character)

func next_character():

	var i = 0
	while i < roster_array.size():
		var next_character = roster_array[next_index]
		next_index = (next_index + 1) % roster_array.size()
		if next_character.alive:
			return next_character
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
