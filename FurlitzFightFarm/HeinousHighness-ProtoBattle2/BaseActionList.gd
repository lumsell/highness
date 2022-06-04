extends ItemList


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_id(new_id):
	id = new_id

func get_id():
	var ret_val
	ret_val = id
	return ret_val

func load_items(items):
	for item in items:
		add_item(item)
