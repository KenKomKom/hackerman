extends Node

class_name Command

@export_enum("rotate", "move", "wait") var type: String

@export var target_node :Node3D
@export_enum("left", "right", "up", "down") var rotate_dir: String
@export var wait_time: float
