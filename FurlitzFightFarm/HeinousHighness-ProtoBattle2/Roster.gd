extends Node


var roster_array
var next_index


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func next_character():
	next_index = (next_index + 1) % roster_array.length
	return roster_array.next_index()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
