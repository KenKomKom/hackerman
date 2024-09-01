extends Area3D

@export var dialogue_path: String
var triggered: bool = false

func _ready():
	triggered = false

func _process(delta: float):
	pass

func _on_body_entered(body: Node3D) -> void:
	if !triggered and body is Player:
		triggered = true
		GlobalEvent.emit_signal("start_dialogue", dialogue_path)
