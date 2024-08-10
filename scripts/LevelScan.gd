extends CharacterBody3D

signal player_detected()

@export var safe_spaces :Array[SafeSpace]
@export var end_target : Node3D
@export var speed : float
@export var wait_time:float

@onready var trigger := $Area3D
@onready var timer := $Timer

var _start_pos
var _dir
var _movement_vector_length = 1
var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_start_pos=global_position
	_dir = (end_target.global_position-_start_pos).normalized()
	trigger.body_entered.connect(_player_entered)
	timer.wait_time=wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (abs(global_position-end_target.global_position).length()<0.1):
		global_position=_start_pos
		can_move=false
		timer.start()
	if can_move:
		velocity=_dir*speed
	else:
		velocity=Vector3.ZERO
	move_and_slide()

func _player_entered(body:Player):
	var safe = false
	for safe_space:Node3D in safe_spaces:
		var safe_position := safe_space.global_position
		if abs(safe_position.x-body.global_position.x)<0.1 and abs(safe_position.z-body.global_position.z)<0.1:
			safe=true
	if not safe:
		print("player entered moving scan")
	return safe

func _on_timer_timeout():
	can_move=true
