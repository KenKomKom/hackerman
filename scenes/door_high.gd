extends Node3D

@onready var door_left = $"door frame_005/door frame_004/door left"
@onready var door_right = $"door frame_005/door frame_004/door right"
@onready var door_collider = $StaticBody3D

# The open position and closed position for the gate
var left_closed = Vector3(0, 0, 0) 
var left_open = Vector3(0.345, 0, 0)
var right_closed = Vector3(0, 0, 0)
var right_open = Vector3(-0.345, 0, 0)

var is_open = false

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	print("Gate setup complete. Waiting for guards to approach.")

func _on_body_entered(body):
	print("Body entered: ", body.name)
	#if (body.is_in_group("Guard") or body.is_in_group("High Guard")):
	if body.is_in_group("Guard"):
		print("Guard detected! Opening gate.")
		open_gate()

func _on_body_exited(body):
	print("Body Exited: ", body.name)
	#if (body.is_in_group("Guard") or body.is_in_group("High Guard")) and !is_any_guard_nearby():
	if body.is_in_group("Guard") and !is_any_guard_nearby():
		print("All guards have left. Closing gate.")
		close_gate()

func open_gate():
	if not is_open:
		is_open = true
		# buka
		door_left.transform.origin = left_open 
		door_right.transform.origin = right_open
		$StaticBody3D/CollisionShape3D.disabled = true
		print("Collider status: ", $StaticBody3D/CollisionShape3D.disabled)

func close_gate():
	if is_open:
		is_open = false
		# tutup
		door_left.transform.origin = left_closed
		door_right.transform.origin = right_closed
		$StaticBody3D/CollisionShape3D.disabled = false
		print("Collider status: ", $StaticBody3D/CollisionShape3D.disabled)

func is_any_guard_nearby() -> bool:
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("Guard"):
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
