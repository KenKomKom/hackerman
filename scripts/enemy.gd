extends CharacterBody3D

#Class Name
class_name Enemy

var movement_speed: float = 0.15
var movement_target_position: Vector3
@export var tile_size:float = 1
@export var current_state: enemy_state
@export var movement_target:Node3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var redo_target_location_timer = $re_target_timer
@onready var ray = $RayCast3D
@onready var states = $states
#@onready var mesh_node = $"shield/shield body"
@onready var mesh_node = $"low tier/antivirus low/Skeleton3D"
@onready var instance_on_cam = $MeshInstance3D2

var central: Central

func _ready():
	position.x = position.snapped(Vector3.ONE * tile_size).x
	position.z = position.snapped(Vector3.ONE * tile_size).z
	position += Vector3(1,0,1) * tile_size / 2
	
	#siapin texture
	var level: int = get_parent().get_parent().id
	
	var hospital_path:= "res://scenes/guards/material/low hospital.tres"
	var bank_path:= "res://scenes/guards/material/low bank.tres"
	var ministry_path:= "res://scenes/guards/material/low ministry.tres"
	var shadow_path:= "res://scenes/guards/material/low shadow.tres"
	
	if(level == 1):
		$"low tier/antivirus low/Skeleton3D/claw".material_override = load(hospital_path)
		$"low tier/antivirus low/Skeleton3D/claw hand".material_override = load(hospital_path)
		$"low tier/antivirus low/Skeleton3D/shield body_007".material_override = load(hospital_path)
		$"low tier/antivirus low/Skeleton3D/shield body_009".material_override = load(hospital_path)
		$"low tier/antivirus low/Skeleton3D/shield body_011".material_override = load(hospital_path)
	elif(level == 2):
		$"low tier/antivirus low/Skeleton3D/claw".material_override = load(bank_path)
		$"low tier/antivirus low/Skeleton3D/claw hand".material_override = load(bank_path)
		$"low tier/antivirus low/Skeleton3D/shield body_007".material_override = load(bank_path)
		$"low tier/antivirus low/Skeleton3D/shield body_009".material_override = load(bank_path)
		$"low tier/antivirus low/Skeleton3D/shield body_011".material_override = load(bank_path)
	elif(level == 3):
		$"low tier/antivirus low/Skeleton3D/claw".material_override = load(ministry_path)
		$"low tier/antivirus low/Skeleton3D/claw hand".material_override = load(ministry_path)
		$"low tier/antivirus low/Skeleton3D/shield body_007".material_override = load(ministry_path)
		$"low tier/antivirus low/Skeleton3D/shield body_009".material_override = load(ministry_path)
		$"low tier/antivirus low/Skeleton3D/shield body_011".material_override = load(ministry_path)
	elif(level == 4):
		$"low tier/antivirus low/Skeleton3D/claw".material_override = load(shadow_path)
		$"low tier/antivirus low/Skeleton3D/claw hand".material_override = load(shadow_path)
		$"low tier/antivirus low/Skeleton3D/shield body_007".material_override = load(shadow_path)
		$"low tier/antivirus low/Skeleton3D/shield body_009".material_override = load(shadow_path)
		$"low tier/antivirus low/Skeleton3D/shield body_011".material_override = load(shadow_path)
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	change_current_state(current_state)

# EnemyState melakukan sesuatu
func _physics_process(delta):
	current_state.do_something(delta)

# Pasang mau target buat pathfinder
func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

# Ganti state trus set up
func change_current_state(state:enemy_state):
	current_state=state
	state.ready_state()

# nengok
func look_towards(dir:Vector3):
	var rad = atan2(-dir.z,dir.x)
	var q = Quaternion(Vector3.UP, rad)
	var tween = create_tween()
	tween.tween_property(
		mesh_node, 
		"quaternion", 
		q, 
		0.1
	)

# Matiin mesh kalo zoom out sama nyalain legenda buat peta zoomout
#func set_visible_by_cam(status):
	#instance_on_cam.set_layer_mask_value(1,status)
	#mesh_node.get_parent().make_visible_on_zoom_out(status)

# Di call pas central run buat Konekin robot
func subscribe_to_central(ctrl : Central):
	central = ctrl

# Di call pas central mati buat diskonek robot
func unsubscribe_to_central():
	central = null
