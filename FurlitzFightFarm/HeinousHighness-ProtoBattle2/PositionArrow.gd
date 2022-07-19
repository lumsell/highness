extends Sprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal direction_chosen(row, line)

var target_row
var target_line

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = .5
	
func set_target_row(new_target):
	target_row = new_target
	print(target_row)

func set_target_line(new_target):
	target_line = new_target
	print(target_line)

func reposition(origin_row, origin_line):
	#flip_h = (target_row == 0)
	print("Origin: " + str(origin_row) + ", " + str(origin_line))
	print("Target: " + str(target_row) + ", " + str(target_line))

	
	var line_dif = target_line - origin_line
	var row_dif = target_row - origin_row
	
	var divisor
	
	if row_dif == 0 && abs(line_dif) == 1:
		divisor = 2
	else:
		divisor = 4
	
	set_position(Vector2((row_dif) * 300, (line_dif) * 300))
	
	var angle = PI * origin_row
	if angle == 0:
		angle = angle + ((line_dif)* (PI/divisor))
	else:
		angle = angle - ((line_dif) * (PI/divisor))
	#if origin_row == origin_line:
	#	angle = angle * -1
	set_rotation(angle)
	


func _on_Area2D_mouse_entered() -> void:
	modulate.a = 1

	print("Target: " + str(target_row) + ", " + str(target_line))

func _on_Area2D_mouse_exited() -> void:
	modulate.a = .5


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("click")
		emit_signal("direction_chosen", target_row, target_line)
