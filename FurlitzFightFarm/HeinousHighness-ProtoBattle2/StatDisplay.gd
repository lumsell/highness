extends VBoxContainer

func _on_StatBlock_health_changed(new_health) -> void:
	$HealthLabel.text = "Health: " + str(new_health)

func _on_StatBlock_ap_changed(new_ap) -> void:
	$APLabel.text = "AP: " + str(new_ap)
