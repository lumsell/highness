extends VBoxContainer

func _on_StatBlock_health_changed(new_health) -> void:
	$HealthLabel.text = "Health: " + str(new_health)

func _on_StatBlock_mana_changed(new_mana) -> void:
	$ManaLabel.text = "Mana: " + str(new_mana)

func _on_StatBlock_stamina_changed(new_stamina) -> void:
	$StamLabel.text = "Stamina: " + str(new_stamina)
