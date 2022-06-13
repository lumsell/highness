extends Node

signal die

signal health_changed(new_health)
signal stamina_changed(new_stamina)
signal mana_changed(new_mana)

var health
var stamina
var mana

var strength

var h_min
var h_max

func _ready() -> void:
	pass
	
func build(in_health, in_stamina, in_mana, in_strength):
	h_max = in_health
	set_health(in_health)
	set_stamina(in_stamina)
	set_mana(in_mana)
	set_strength(in_strength)
	

func set_health(new_health):
	health = new_health
	if health <= 0:
		emit_signal("die")
	emit_signal("health_changed", health)

func get_health():
	return health

func set_stamina(new_stamina):
	stamina = new_stamina
	emit_signal("stamina_changed", stamina)

func get_stamina():
	return stamina
	
func set_mana(new_mana):
	mana = new_mana
	emit_signal("mana_changed", new_mana)

func set_strength(new_strength):
	strength = new_strength

func get_strength():
	return strength
