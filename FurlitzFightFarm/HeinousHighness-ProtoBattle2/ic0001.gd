extends Node


var local_id: String = "ic0001"
var local_name: String = "AP Potion"



func execute(target_stats):
	target_stats.set_ap(target_stats.get_ap() + 5)

func perform(target_stats):
	target_stats.set_up(target_stats.get_ap() + 4)
