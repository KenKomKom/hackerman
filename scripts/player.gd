extends CharacterBody3D

class_name Player

@onready var ray = $RayCast3D
@onready var mesh_node = $"hacker animated"
@onready var anim_player = $"hacker animated/AnimationPlayer"
@onready var anim_tree = $"hacker animated/AnimationTree"
@onready var timer = $Timer

@export var animation_speed := 5.0
@export var tile_size = 1
#@export_enum("interact", "hack", "download", "none") var interaction: String 
#@export_enum("low_kill", "high_kill", "none") var is_killed: String 

# untuk mengontrol player bisa berjalan atau tidak. (ex: buka kotak sampah player tidak bisa gerak)
var can_move = true
var moving = false #state sedang gerak

var ease_move = 0 #timer buat forced dir gerak
var forced_dir = "stand" # input yg masuk tengah gerak
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
	
	anim_tree.active = true
	#print(anim_player.current_animation)

func _physics_process(delta):
	update_animation("")
	move(delta)

func look_towards(dir:Vector3):
	var rad = atan2(-dir.z,dir.x) + (PI/2)
	var q = Quaternion(Vector3.UP, rad)
	var tween = create_tween()
	tween.tween_property(
		mesh_node, 
		"quaternion", 
		q, 
		0.1
	)

# gerakin karakternya
func move(delta):
	if !can_move:
		return
		
	if moving:
		# Animasiin pergerakannya
		#ease_move-=delta
		look_towards(target_position_after_move - global_position)
		global_position = lerp(global_position, target_position_after_move, 0.175)
		if (global_position - target_position_after_move).length() < 0.175:
			global_position = target_position_after_move
			moving = false
	else:
		# Terima input dari user buat arah gerak
		for dir in inputs.keys():
			if dir != "stand" and Input.is_action_pressed(dir):
				last_dir = dir
				step(dir)

#mo jalan ke arah mana
func step(dir):
	if !can_move:
		return
	
	#if moving:
		## Set up coyote move -> cari di google coyote jump
		#ease_move = 0.05
		#forced_dir = dir
		#return
	
	# Set raycast ke arah gerak pemain
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	GlobalEvent.emit_signal("player_move", dir)
	
	# gak gerak tapi user ada sisa input tengah pergerakan sebelumnya
	if not moving and ease_move > 0:
		# Gerak kalo raycat gk ketemu apapun
		if !ray.is_colliding():
			moving = true
			ease_move=0
			target_position_after_move = global_position + inputs[forced_dir] * tile_size
	
	# gak gerak
	if not moving:
		if !ray.is_colliding():
			moving = true
			target_position_after_move = global_position + inputs[dir] * tile_size

func update_animation(animation: String):
	
	#klo nggak ada command utk animation tertentu
	if (animation == "none" or animation == "") :
		#cek dia gerak atau nggak
		if (Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right") or moving) and can_move:
			anim_tree["parameters/conditions/run"] = true
			anim_tree["parameters/conditions/idle"] = false
			#print(anim_tree["parameters/conditions/run"])
		else:
			anim_tree["parameters/conditions/run"] = false
			anim_tree["parameters/conditions/idle"] = true
	
	#cek jenis interaction
	if animation == "interact":
		can_move = false
		print("hrsnya abisni animasi jalan lol")
		anim_tree["parameters/conditions/interact"] = true
		#anim_tree.get("parameters/playback").travel("interact")
		print("ini harusnya interact tp kok enggak")
		
		timer.wait_time = anim_player.get_animation("hacker - interact").length - 0.15
		timer.start()
	
	elif animation == "hack":
		can_move = false
		anim_tree["parameters/conditions/hack"] = true
		#anim_tree.get("parameters/playback").travel("hack")
		
		timer.wait_time = anim_player.get_animation("hacker - hack").length - 0.15
		timer.start()
	
	elif animation == "download":
		can_move = false
		anim_tree["parameters/conditions/download"] = true
		anim_tree["parameters/conditions/run"] = false
		anim_tree["parameters/conditions/idle"] = false
		
		timer.wait_time = anim_player.get_animation("hacker - download").length - 0.15
		timer.start()
	
	else:
		anim_tree["parameters/conditions/interact"] = false
		anim_tree["parameters/conditions/hack"] = false
		anim_tree["parameters/conditions/download"] = false
	
	#print(anim_tree["parameters/conditions/interact"])
	
	#run animasi sesuai cara mati nya
	if animation == "low_kill":
		anim_tree["parameters/conditions/low_kill"] = true
	elif animation == "high_kill":
		anim_tree["parameters/conditions/high_kill"] = true
	else: 
		anim_tree["parameters/conditions/high_kill"] = false
		anim_tree["parameters/conditions/low_kill"] = false

func stop_animation():
	can_move = true
	anim_tree["parameters/conditions/download"] = false
	anim_tree["parameters/conditions/run"] = false
	anim_tree["parameters/conditions/idle"] = true
	timer.stop()


func _on_timer_timeout():
	can_move = true
