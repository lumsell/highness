extends Node2D

var speed = 50
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

func _process(delta):
	if moveLeft == true:
		position.x -= speed * delta
	if moveRight == true:
		position.x += speed * delta
	if moveUp == true:
		position.y -= speed * delta
	if moveDown == true:
		position.y += speed * delta

