extends Node




var local_id: String = "ax0001"
var local_name: String = "Swap"

var row_limit = 2 #shouldn't matter

var cost = 1

var origin_row
var origin_line

var target_row
var target_line

var base_arrow = preload("res://PositionArrow.tscn")
# Called when the node enters the scene tree for the first time.

func get_id() -> String:
	return local_id
	
func get_name() -> String:
	return local_name
	
func get_row_limit():
	return row_limit
	
#this might not work check later
func cost_check(user_stats):
	var results = [true, "Stamina"]
	if user_stats.get_stamina() < cost:
		results[0] = false
	return results

func create_options(character_row, character_line):
	origin_row = character_row
	origin_line = character_line
	
	var arrow = base_arrow.instance()
	
	target_row = (character_row + 1) % 2
	arrow.set_target_row(target_row)
	arrow.set_target_line(0)
	#arrow.flip_h = (target_row == 0)
	#arrow.set_position(Vector2((target_row - origin_row) * 300, 0))
	arrow.reposition(origin_row, 0)
	return [arrow]
	

func perform(user_stats):
	user_stats.set_stamina(user_stats.get_stamina() - cost)
	
func execute(position_matrix, target_row, target_line):
	print("Executing: " + local_name)
	var ret_matrix = [position_matrix[1], position_matrix[0]]
	return ret_matrix
	#put the code for changing positions here?
