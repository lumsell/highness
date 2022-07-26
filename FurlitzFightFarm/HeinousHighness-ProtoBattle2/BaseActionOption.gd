extends Sprite

var generic_one = preload("res://ArtAssets/option_one_generic.png")
var generic_two = preload("res://ArtAssets/option_two_generic.png")
var generic_three = preload("res://ArtAssets/option_three_generic.png")

var option_value

signal option_selected(option_value)

var scale_unselected
var scale_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#be a little worried about this, might get weird with resolutions idk
	#scale = scale * .2
	hide()
	modulate.a = .75
	
	scale_unselected = scale
	scale_selected = scale * 1.2

func set_value(new_value):
	option_value = new_value
	
	match option_value:
		1:
			set_texture(generic_one)
		2:
			set_texture(generic_two)
		3:
			set_texture(generic_three)

func get_value():
	return option_value

func select():
	modulate.a = 1
	scale = scale_selected
	print("Debug note: select")
	
func deselect():
	modulate.a = .75
	scale = scale_unselected
	

func _on_Area2D_mouse_entered() -> void:
	modulate.a = 1


func _on_Area2D_mouse_exited() -> void:
	if scale != scale_selected:
		modulate.a = .75


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("click")
		emit_signal("option_selected", option_value)


