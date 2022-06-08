extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var local_id : String = "ad0001"
var local_name : String = "Block"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_id():
	return local_id
	
func get_name():
	return local_name
	
func execute():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
