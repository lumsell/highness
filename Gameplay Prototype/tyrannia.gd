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
		$RayCastLeft.force_raycast_update()
		$RayCastLeft2.force_raycast_update()
		if !$RayCastLeft.is_colliding() || !$RayCastLeft2.is_colliding():
			position.x -= speed * delta
	if moveRight == true:
		$RayCastRight.force_raycast_update()
		$RayCastRight2.force_raycast_update()
		if !$RayCastRight.is_colliding() || !$RayCastRight2.is_colliding():
			position.x += speed * delta
	if moveUp == true:
		$RayCastUp.force_raycast_update()
		if !$RayCastUp.is_colliding():
			position.y -= speed * delta
	if moveDown == true:
		$RayCastDown.force_raycast_update()
		if !$RayCastDown.is_colliding():
			position.y += speed * delta

