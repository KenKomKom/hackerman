extends CharacterBody3D


@onready var ray = $RayCast3D
@onready var animated_sprite = $AnimatedSprite3D

@export var animation_speed := 7.0
@export var tile_size = 8.0

# untuk mengontrol player bisa berjalan atau tidak. (ex: buka kotak sampah player tidak bisa gerak)
var is_active = true

var moving = false #state sedang gerak

var ease_move=0 #timer buat forced dir gerak
var forced_dir="stand" # input yg masuk tengah gerak
var last_dir = "stand" # arah terakhir gerak
var target_position_after_move :Vector3

var inputs = {"right": Vector3(0,0,-1),
			"left": Vector3(0,0,1),
			"up": Vector3(-1,0,0),
			"down": Vector3(1,0,0),
			"stand" : Vector3(0,0,0)}

func _ready():
	position.x = position.snapped(Vector3.ONE * tile_size).x
	position.z = position.snapped(Vector3.ONE * tile_size).z
	position += Vector3(1,0,1) * tile_size / 2

func _physics_process(delta):
	move(delta)

func move(delta):
	if moving:
		ease_move-=delta
		global_position = lerp(global_position,target_position_after_move,0.2)
		if (global_position-target_position_after_move).length()<0.08:
			global_position=target_position_after_move
			moving=false
	elif is_active:
		for dir in inputs.keys():
			if dir!="stand" and Input.is_action_pressed(dir):
				last_dir=dir
				step(dir)

func step(dir):
	if moving:
		ease_move = 0.02
		forced_dir = dir
		return
	
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	GlobalEvent.emit_signal("player_move", dir)
	
	# gak gerak tapi user ada sisa input tengah pergerakan sebelumnya
	if not moving and ease_move > 0:
		if !ray.is_colliding():
			moving=true
			ease_move=0
			animate_movement(forced_dir, true)
			target_position_after_move = global_position + inputs[forced_dir] * tile_size
			forced_dir="stand"
			return
	
	# gak gerak
	if not moving:
		if !ray.is_colliding():
			moving = true
			animate_movement(dir, true)
			target_position_after_move = global_position + inputs[dir] * tile_size

func animate_movement(dir, is_moving):
	pass
	#if is_moving:
		#if dir=="left":
			#animated_sprite.play("idle")
			#animated_sprite.flip_h=true
		#elif dir =="right":
			#animated_sprite.play("idle")
			#animated_sprite.flip_h=false
		#elif dir =="down":
			#animated_sprite.play("idle")
		#elif dir == "up":
			#animated_sprite.play("idle")
