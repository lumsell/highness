extends Node




var local_id: String = "ax0001"
var local_name: String = "Swap"

var row_limit = 2 #shouldn't matter

var cost = 1

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
	
func perform(user_stats):
	user_stats.set_stamina(user_stats.get_stamina() - cost)
	
func execute(target_stats):
	target_stats.set_health(target_stats.get_health())
	
	#put the code for changing positions here?
