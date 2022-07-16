extends Node

signal die

signal health_changed(new_health)
signal ap_changed(new_ap)

var health
var ap
var strength

var h_min
var h_max

var ap_min
var ap_max

func _ready() -> void:
	pass
	
func build(in_health, in_ap, in_strength):
	h_max = in_health
	set_health(in_health)
	ap_max = in_ap
	set_ap(in_ap)
	set_strength(in_strength)
	

func set_health(new_health):
	health = min(new_health, h_max)
	if health <= 0:
		emit_signal("die")
	emit_signal("health_changed", health)

func get_health():
	return health

func set_ap(new_ap):
	ap = min(new_ap, ap_max)
	emit_signal("ap_changed", ap)

func get_ap():
	return ap

func set_strength(new_strength):
	strength = new_strength

func get_strength():
	return strength
