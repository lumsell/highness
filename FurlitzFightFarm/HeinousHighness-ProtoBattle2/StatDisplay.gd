extends VBoxContainer

func _on_StatBlock_health_changed(new_health) -> void:
	$HealthLabel.text = "Health: " + str(new_health)

func _on_StatBlock_ap_changed(new_stamina) -> void:
	$StamLabel.text = "AP: " + str(new_stamina)
