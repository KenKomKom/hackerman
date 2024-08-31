extends Node

class_name enemy_state

@export var next_target: Array[enemy_state]
@onready var parent_enemy = get_parent().get_parent()

# Run saat pertama kali set up node
func _ready():
	pass # Replace with function body.

# Function dilakuin saat pertama kali
# masuk ke state dari state lain
func ready_state():
	pass

# Function di run di _process
func do_something(delta):
	pass
	
