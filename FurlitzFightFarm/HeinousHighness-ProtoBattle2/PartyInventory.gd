extends TabContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal selection_made(selected_item)

var active_item
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func load_items(inventory):
	
	for item in inventory:
		
		var item_scene = load("res://" + item + ".tscn")
		var item_node = item_scene.instance()
		add_child(item_node)
		match item.substr(1,1):
			"c":
				$Consumables.load_node(item_node)
			"e":
				$Equipment.load_node(item_node)
			"m":
				$Misc.load_node(item_node)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Consumables_item_selected(index: int) -> void:
	active_item = get_node($Consumables.get_id_at(index))
	print(active_item.get_id())
	emit_signal("selection_made", active_item)
