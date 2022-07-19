extends Node2D

signal action_ready()


var local_id: String = "ax0003"
var local_name: String = "Swing"

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
	var results = [true, "AP"]
	if user_stats.get_ap() < cost:
		results[0] = false
	return results
	
func create_options(character_row, character_line):
	origin_row = character_row
	origin_line = character_line
	var arrow_one = base_arrow.instance()
	var arrow_two = base_arrow.instance()
	
	#need to add 1 to the row only when line is 0
	#actually, needs to not add 1 when line is 2?
	print("Arrow one")
	arrow_one.set_target_row((character_row + (character_line + 1) % 3) % 2)
	arrow_one.set_target_line(max(character_line - 1, 0))


	#need to add 1 to the row only when line is 2
	#needs to not add 1 when line is 0
	print("Arrow two")
	arrow_two.set_target_row((character_row + (3 - character_line) % 3) % 2)
	arrow_two.set_target_line(min(character_line + 1, 2))
	
	arrow_one.reposition(character_row, character_line)
	arrow_two.reposition(character_row, character_line)
	
	add_child(arrow_one)
	add_child(arrow_two)
	
	arrow_one.connect("direction_chosen", self, "_on_Arrow_direction_chosen")
	arrow_two.connect("direction_chosen", self, "_on_Arrow_direction_chosen")
	
func _on_Arrow_direction_chosen(row, line):
	target_row = row
	target_line = line
	emit_signal("action_ready")
	
func perform(user_stats):
	user_stats.set_ap(user_stats.get_ap() - cost)
	
func execute(position_matrix):
	print("Executing: " + local_name)
	var ret_matrix = [[null, null, null], [null,null,null]]
	
	ret_matrix[target_row][target_line] = position_matrix[origin_row][origin_line]
	
	for i in 2:
		var line_difference = origin_line - target_line
		var row_difference = target_row - origin_row
		
		if target_line == 1:
			origin_line = 1
			target_line = origin_line + line_difference
			
			origin_row = (target_row + 1) % 2
			target_row = origin_row
		else:
			origin_row = (origin_row + abs(line_difference)) % 2
			origin_line = (target_line + 2) % 4
			
			target_row = (origin_row + abs(line_difference)) % 2
			target_line = 1 + line_difference
		
		ret_matrix[target_row][target_line] = position_matrix[origin_row][origin_line]
		
	return ret_matrix
