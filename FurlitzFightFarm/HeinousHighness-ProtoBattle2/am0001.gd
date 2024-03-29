extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var local_id : String = "am0001"
var local_name : String = "Kazoo"

#Cost is mana
var cost = 4

var row_limit = 0 #only usable in the back row

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_id():
	return local_id
	
func get_name():
	return local_name

func cost_check(user_stats):
	var results = [false, "AP"]
	if user_stats.get_ap() >= cost:
		results[0] = true
	return results

func get_row_limit():
	return row_limit

func execute():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
