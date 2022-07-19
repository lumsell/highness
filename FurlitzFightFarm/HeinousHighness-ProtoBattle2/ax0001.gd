extends Node2D


signal action_ready()

var local_id: String = "ax0001"
var local_name: String = "Swap"

var row_limit = 2 #shouldn't matter

var cost = 1

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
	var arrow = base_arrow.instance()
	
	arrow.set_target_row((character_row + 1) % 2)
	arrow.set_target_line(0)
	#arrow.flip_h = (target_row == 0)
	#arrow.set_position(Vector2((target_row - origin_row) * 300, 0))
	arrow.reposition(character_row, 0)
	add_child(arrow)
	arrow.connect("direction_chosen", self, "_on_Arrow_direction_chosen")
	
func _on_Arrow_direction_chosen(_row, _line):
	emit_signal("action_ready")

func perform(user_stats):
	user_stats.set_ap(user_stats.get_ap() - cost)
	
func execute(position_matrix):
	print("Executing: " + local_name)
	var ret_matrix = [position_matrix[1], position_matrix[0]]
	return ret_matrix
	#put the code for changing positions here?
