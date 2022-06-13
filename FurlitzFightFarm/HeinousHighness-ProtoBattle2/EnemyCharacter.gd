extends Sprite

# Returns the character's ID to let the BattleController know what the player
# is targetting
signal enemy_targeted(id)

var character_id: String = "ce0001"
var health = 15
var stamina = 15
var mana = 15
var strength = 15

func _ready() -> void:
	$StatBlock.build(health, stamina, mana, strength)

# Sends the enemy_targeted signal when the character is clicked on
func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("click")
		emit_signal("enemy_targeted", character_id)

func apply_action(action):
	action.execute($StatBlock)


func _on_StatBlock_die() -> void:
	hide()
