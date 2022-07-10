extends Node




var local_id: String = "ax0002"
var local_name: String = "Cycle"

var row_limit = 2 #shouldn't matter

var cost = 1

var origin_row
var origin_line

var base_arrow = preload("res://PositionArrow.tscn")

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
	var arrow_one = base_arrow.instance()
	var arrow_two = base_arrow.instance()
	
	origin_row = character_row
	origin_line = character_line
	#looks like it works so far but treat this with respect and fear
	

	print("Arrow one:")
	arrow_one.set_target_row((character_row + 1) % 2)
	arrow_one.set_target_line(((character_line % 2) + 1) % 3)
	
	arrow_one.reposition(origin_row, origin_line)
	
	print("Arrow two:")
	arrow_two.set_target_row((character_row + character_line) % 2)
	arrow_two.set_target_line(((character_line + 2) * ((character_line + 1) % 3)) % 3)
	
	arrow_two.reposition(origin_row, origin_line)
	
	return [arrow_one, arrow_two]
	
func perform(user_stats):
	user_stats.set_stamina(user_stats.get_stamina() - cost)
	
func execute(position_matrix, target_row, target_line):
	print("Executing: " + local_name)
	var ret_matrix = [[null, null, null], [null, null, null]]
	
	ret_matrix[target_row][target_line] = position_matrix[origin_row][origin_line]
	
	for i in 2:

		var line_difference = (target_line - origin_line)
			
		origin_row = target_row
		origin_line = target_line
			
		#this means they moved from the one spot into a two spot
		if target_line % 2 == 0: #if current character is moving out of a corner spot
			line_difference = line_difference * -1
			if abs(line_difference) != 2: #if previous character only moved one line
				target_line = (origin_line + 2) % 4 #current character switches to other corner of same row
			else: #if previous character moved two lines
				target_row = (origin_row + 1) % 2 #current character moves to mid line of opposite row
				target_line = 1
		else: #if current character is moving out of a mid spot
			target_row = (origin_row + 1) % 2
			target_line = origin_line + line_difference
	
		ret_matrix[target_row][target_line] = position_matrix[origin_row][origin_line]
	
	return ret_matrix
	
	#put the code for changing positions here?
