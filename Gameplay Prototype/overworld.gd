extends Node2D

onready var nav2d : Navigation2D = $Navigation2D
onready var player : KinematicBody2D = $tyrannia
onready var enemy1 : Node2D	 = $grumpkin
onready var enemy2 : Node2D = $grumpkin2
onready var debugLine : Line2D = $debugPathLine
onready var debugLine2 : Line2D = $debugPathLine2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemy1.path = get_path_to_player(player, enemy1)
	enemy2.path = get_path_to_player(player, enemy2)
	
	debugLine.points = enemy1.path
	debugLine2.points = enemy2.path
	
	
func get_path_to_player(player, enemy):
	return nav2d.get_simple_path(enemy.position, player.position)
