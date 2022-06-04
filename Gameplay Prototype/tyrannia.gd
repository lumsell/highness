extends KinematicBody2D

var speed = 70
var moveLeft = false
var moveRight = false
var moveUp = false
var moveDown = false
var animationTree = null
var animationState = null

func _ready():
	animationTree = $AnimationTree
	animationState = animationTree.get("parameters/playback")

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
	if event.is_action_pressed("run"):
		speed = 120
	if event.is_action_released("run"):
		speed = 70

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
	var collision = move_and_slide(movement)
	if moveLeft == true || moveRight == true || moveUp == true || moveDown == true:
		animationState.travel("walk")
	else:
		animationState.travel("idle")
		

