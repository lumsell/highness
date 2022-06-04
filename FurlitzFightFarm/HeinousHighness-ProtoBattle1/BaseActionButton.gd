extends Button

signal selection_made(selection_sig)

var signature
var id

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_signature(new_sig):
	signature = new_sig
	text = signature

func set_id(new_id):
	id = new_id
	
func get_id():
	var ret_val
	ret_val = id
	return ret_val
	
func _on_BaseActionButton_pressed() -> void:
	emit_signal("selection_made", id)
