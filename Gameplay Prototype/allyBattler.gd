extends Sprite


#list of characters in the current battle
onready var battleController = $battleController

# Called when the node enters the scene tree for the first time.
func _ready():
	battleController.registerBattler(self)
	#character objects have to register themselves with the battle controller


