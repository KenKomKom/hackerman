extends Node

class_name enemy_state
@export var next_target:Array[enemy_state]
@onready var parent_enemy = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# TO BE OVERRIDED
func ready_state():
	pass

# TO BE OVERRIDED
func do_something(delta):
	pass
