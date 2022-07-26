extends Sprite

# Returns the character's ID to let the BattleController know what the player
# is targetting
signal enemy_targeted(id)
signal enemy_action(target, action)
signal enemy_dead(local_id)

var local_id: String = "ce0001"
var health = 15
var ap = 15
var strength = 3

var back_top = Vector2(1, 1)
var back_mid = Vector2(1, 2.75)
var back_low = Vector2(1, 4.5)

var front_top = Vector2(2, 1)
var front_mid = Vector2(2, 2.75)
var front_low = Vector2(2, 4.5)

var positions = [[back_top, back_mid, back_low],[front_top, front_mid, front_low]]

var active_action

var alive

func _ready() -> void:
	alive = true
	$StatBlock.build(health, ap, strength)

func set_id(new_id):
	name = new_id
	local_id = new_id
	
func start_turn(player_positions, npc_positions):
	yield(get_tree().create_timer(3.0), "timeout")
	
	var targets = Array()
	for character in player_positions[1]:
		if character != null and character.alive:
			targets.append(character)
	
	var target = null
	
	if targets.size() > 0:
		target = targets[randi() % targets.size()]
	
	active_action = load("res://aa0001.tscn").instance()
	add_child(active_action)
	
	if active_action.cost_check($StatBlock):
		active_action.create_options($StatBlock)
		emit_signal("enemy_action", target, active_action)
	else:
		print(name + ": pass")
		emit_signal("enemy_action", null, null)

func end_turn():
	if active_action != null:
		remove_child(active_action)
		active_action.queue_free()
		active_action = null

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

func perform_action(action):
	action.perform($StatBlock)

func _on_StatBlock_die() -> void:
	alive = false
	$StatDisplay.hide()
	emit_signal("enemy_dead", local_id)
	set_rotation(PI/2)
