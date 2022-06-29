extends Node




var local_id: String = "aa0001"
var local_name: String = "Punch"

var base_damage = 1
var damage

var row_limit = 1 #only usable in the front row

var cost = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Punch node turned on")

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
	damage = base_damage + user_stats.get_strength()
	
func execute(target_stats):
	target_stats.set_health(target_stats.get_health() - damage)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
