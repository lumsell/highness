extends Node2D

export var speed = 50
var path = PoolVector2Array() 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if path.size() == 0:
		pass
	var move_distance = speed * delta
	
	var start_point = position
	for i in range(path.size()):
		var distance_to_next_point = start_point.distance_to(path[0])
		if move_distance <= distance_to_next_point and move_distance >= 0.0:
			position = start_point.linear_interpolate(path[0], move_distance / distance_to_next_point)
			break
		elif move_distance < 0.0:
			position = path[0]
		move_distance -- distance_to_next_point
		start_point = path[0]
		path.remove(0)
	
	
		
	
	
