extends Node2D

var speed = 100
var moveLeft = false
var moveRight = false
var moveUp = false
var moveDown = false

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_left"):
		moveLeft = true
	if event.is_action_pressed("ui_right"):
		moveRight = true
	if event.is_action_pressed("ui_up"):
		moveUp = true
	if event.is_action_pressed("ui_down"):
		moveDown = true
	if event.is_action_released("ui_left"):
		moveLeft = false
	if event.is_action_released("ui_right"):
		moveRight = false
	if event.is_action_released("ui_up"):
		moveUp = false
	if event.is_action_released("ui_down"):
		moveDown = false

func _physics_process(delta):
	var movement := Vector2(0,0) 
	if moveLeft:
		movement += Vector2.LEFT
	if moveRight:
		movement += Vector2.RIGHT
	if moveUp: 
		movement += Vector2.UP
	if moveDown:
		movement += Vector2.DOWN
	movement *= (speed)
	var collision = $KinematicBody2D.move_and_slide(movement)

