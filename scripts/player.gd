extends CharacterBody3D


@onready var ray = $RayCast3D
@onready var animated_sprite = $AnimatedSprite3D

@export var animation_speed = 7
@export var tile_size = 8

# untuk mengontrol player bisa berjalan atau tidak. (ex: buka kotak sampah player tidak bisa gerak)
var is_active = true

var moving = false #state sedang gerak

var ease_move=0 #timer buat forced dir gerak
var forced_dir=Vector2.ZERO # input yg masuk tengah gerak
var last_dir = "down" # arah terakhir gerak

var inputs = {"right": Vector3(0,0,-1),
			"left": Vector3(0,0,1),
			"up": Vector3(-1,0,0),
			"down": Vector3(1,0,0),
			"stand" : Vector3(0,0,0)}

func _ready():
	position = position.snapped(Vector3.ONE * tile_size)
	position += Vector3(0,0,0) * tile_size / 2

func _process(delta):
	move(delta)

func move(delta):
	if moving:
		ease_move-=delta
	elif is_active:
		var key_is_pressed=false
		for dir in inputs.keys():
			if dir!="stand" and Input.is_action_pressed(dir):
				key_is_pressed=true
				last_dir=dir
				step(dir)
		if not key_is_pressed:
			animate_movement(last_dir, false)

func step(dir):
	if moving:
		ease_move = 0.01
		forced_dir = dir
		return
	
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()

	# gak gerak tapi user ada sisa input tengah pergerakan sebelumnya
	if not moving and ease_move > 0:
		if !ray.is_colliding():
			var tween = get_tree().create_tween()
			ease_move=0
			animate_movement(forced_dir, true)
			tween.tween_property(self, "global_position",global_position + inputs[forced_dir] * tile_size, 1.0 / animation_speed)
			await tween.finished
			forced_dir="stand"
			return
	# gak gerak
	if not moving:
		if !ray.is_colliding():
			moving = true
			animate_movement(dir, true)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", global_position + inputs[dir] * tile_size, 1.0 / animation_speed)
			await tween.finished
			moving = false


func animate_movement(dir, is_moving):
	if is_moving:
		if dir=="left":
			animated_sprite.play("idle")
			animated_sprite.flip_h=true
		elif dir =="right":
			animated_sprite.play("idle")
			animated_sprite.flip_h=false
		elif dir =="down":
			animated_sprite.play("idle")
		elif dir == "up":
			animated_sprite.play("idle")
