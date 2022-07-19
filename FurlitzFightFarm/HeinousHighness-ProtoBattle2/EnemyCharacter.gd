extends Sprite

# Returns the character's ID to let the BattleController know what the player
# is targetting
signal enemy_targeted(id)
signal enemy_action(action)


var local_id: String = "ce0001"
var health = 15
var ap = 15
var strength = 15

var back_top = Vector2(1, 1)
var back_mid = Vector2(1, 2.75)
var back_low = Vector2(1, 4.5)

var front_top = Vector2(2, 1)
var front_mid = Vector2(2, 2.75)
var front_low = Vector2(2, 4.5)

var positions = [[back_top, back_mid, back_low],[front_top, front_mid, front_low]]

var alive

func _ready() -> void:
	alive = true
	$StatBlock.build(health, ap, strength)

func set_id(new_id):
	local_id = new_id

	
func start_turn():
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("enemy_action", "placeholder")

func end_turn():
	pass

func reposition(new_row, new_line):
	var modifier_x = get_viewport_rect().size.x
	var modifier_y = get_viewport_rect().size.y
	var pos_modifier = Vector2(modifier_x, 0)
	var res_modifier = Vector2(modifier_x / -10, modifier_y / 6)
	
	set_position(pos_modifier + (positions[new_row][new_line] * res_modifier))
	
# Sends the enemy_targeted signal when the character is clicked on
func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("click")
		emit_signal("enemy_targeted", local_id)

func apply_action(action):
	action.execute($StatBlock)


func _on_StatBlock_die() -> void:
	alive = false
	hide()
