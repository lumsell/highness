extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal run_out

var local_id: String = "ic0001"
var local_name: String = "Stamina Potion"

var current_amount = 4

# Called when the node enters the scene tree for the first time.

func use(target_stats):
	target_stats.set_stamina(target_stats.get_stamina() + 5)
	current_amount -= 1
	if current_amount <= 0:
		emit_signal("run_out")

func get_id():
	return local_id

func get_name():
	return local_name
