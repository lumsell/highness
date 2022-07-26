extends Node2D


signal action_ready()

var local_id: String = "aa0001"
var local_name: String = "Punch"

#var base_damage = 1
var damage

var row_limit = 1 #only usable in the front row

var cost = 4

var selected_option

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = 0

func get_id() -> String:
	return local_id
	
func get_name() -> String:
	return local_name
	
func get_row_limit():
	return row_limit
	
func create_options(user_stats):
	#damage = base_damage
	var cost_check = user_stats.get_ap() - cost
	$OptionOne.set_value(1)
	selected_option = $OptionOne
	if cost_check < 0:
		print("Not enough AP")
	else:
		$OptionOne.show()
		
		if cost_check >= 1:
			$OptionTwo.set_value(2)
			$OptionTwo.show()
		if cost_check >= 2:
			$OptionThree.set_value(3)
			$OptionThree.show()
	
		$OptionOne.select()
		emit_signal("action_ready")
	
#this might not be necessary, try to fold into the create_option function
func cost_check(user_stats):
	return user_stats.get_ap() > cost
	
func perform(user_stats):
	user_stats.set_ap(user_stats.get_ap() - cost - selected_option.get_value())
	damage = user_stats.get_strength()
	
func execute(target_stats):
	target_stats.set_health(target_stats.get_health() - (damage + selected_option.get_value()))

func _on_Option_option_selected(option_value) -> void:
	selected_option.deselect()
	match option_value:
		1:
			selected_option = $OptionOne
		2:
			selected_option = $OptionTwo
		3:
			selected_option = $OptionThree
	selected_option.select()
	
	emit_signal("action_ready")
