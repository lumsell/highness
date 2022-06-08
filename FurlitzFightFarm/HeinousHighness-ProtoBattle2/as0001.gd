extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var local_id: String = "as0001"
var local_name: String = "Punch"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Punch node turned on")

func get_id() -> String:
	return local_id
	
func get_name() -> String:
	return local_name
	
func execute() -> int:
	return 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
