extends Node3D

@onready var door_left = $"door frame_007/door left_002"
@onready var door_right = $"door frame_007/door right_002"
@onready var door_collider = $StaticBody3D

# The open position and closed position for the gate
var left_closed = Vector3(0.442, 0, 0) 
var left_open = Vector3(0.89, 0, 0)
var right_closed = Vector3(-0.442, 0, 0)
var right_open = Vector3(-0.89, 0, 0)

var unlocked = false
var is_open = false
var speed = 4.0  # Speed of the door movement

func _process(delta):
	if is_open:
		door_left.transform.origin = door_left.transform.origin.lerp(left_open, speed * delta)
		door_right.transform.origin = door_right.transform.origin.lerp(right_open, speed * delta)
	else:
		door_left.transform.origin = door_left.transform.origin.lerp(left_closed, speed * delta)
		door_right.transform.origin = door_right.transform.origin.lerp(right_closed, speed * delta)

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	
	#setup material
	var level: int = get_parent().get_parent().id
	
	var hospital_path:= "res://3dassets/envi/props/gates/low/door_low_hospital.tres"
	var bank_path:= "res://3dassets/envi/props/gates/low/door_low_bank.tres"
	var ministry_path:= "res://3dassets/envi/props/gates/low/door_low_ministry.tres"
	var shadow_path:= "res://3dassets/envi/props/gates/low/door_low_shadow.tres"
	
	if(level == 1):
		$"door frame_007".material_override = load(hospital_path)
		$"door frame_007/door left_002".material_override = load(hospital_path)
		$"door frame_007/door right_002".material_override = load(hospital_path)
	elif(level == 2):
		$"door frame_007".material_override = load(bank_path)
		$"door frame_007/door left_002".material_override = load(bank_path)
		$"door frame_007/door right_002".material_override = load(bank_path)
	elif(level == 3):
		$"door frame_007".material_override = load(ministry_path)
		$"door frame_007/door left_002".material_override = load(ministry_path)
		$"door frame_007/door right_002".material_override = load(ministry_path)
	elif(level == 4):
		$"door frame_007".material_override = load(shadow_path)
		$"door frame_007/door left_002".material_override = load(shadow_path)
		$"door frame_007/door right_002".material_override = load(shadow_path)

func _on_body_entered(body):
	#if (body.is_in_group("Guard") or body.is_in_group("High Guard")):
	if body.is_in_group("Guard"):
		open_gate()

func _on_body_exited(body):
	#if (body.is_in_group("Guard") or body.is_in_group("High Guard")) and !is_any_guard_nearby():
	if body.is_in_group("Guard") and !is_any_guard_nearby():
		close_gate()

func open_gate():
	if not is_open:
		is_open = true
		$StaticBody3D/CollisionShape3D.set_deferred("disabled", true)

func close_gate():
	if !unlocked and is_open:
		is_open = false
		$StaticBody3D/CollisionShape3D.set_deferred("disabled", false)

func interact():
	unlocked = true
	open_gate()
	pass

func is_any_guard_nearby() -> bool:
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("Guard"):
			return true
	return false
