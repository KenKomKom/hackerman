extends MeshInstance3D

@export var tile_size :=1
@onready var timer := $Timer
@onready var anim_player := $AnimationPlayer

@export var warmup_speed: float = 1 #kecepatan lantai warmup muncul
@export var fire_speed: float = 1 #kecepatan api nya muncul
@export var offset: float = 0.001 #offset time untuk api nya muncul
@export var wait_time: float = 1 #default wait time

var onfire := false
var level: int

func _ready():
	position.x = position.snapped(Vector3.ONE * tile_size).x
	position.z = position.snapped(Vector3.ONE * tile_size).z
	position += Vector3(1,0,1) * tile_size / 2
	anim_player.set_speed_scale(warmup_speed)
	
	#set default pos
	$base.transparency = 1
	$fire.position.y = -1.264
	level = get_parent().get_parent().id
	
	#set materials
	if(level == 1):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_hospital.tres")
		$base.material_override = load("res://3dassets/envi/props/firewall/material/firewall_base_hospital.tres")
	elif(level == 2):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_bank.tres")
		$base.material_override = load("res://3dassets/envi/props/firewall/material/firewall_base_bank.tres")
	elif(level == 3):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_ministry.tres")
		$base.material_override = load("res://3dassets/envi/props/firewall/material/firewall_base_ministry.tres")
	elif(level == 4):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_shadow.tres")
		$base.material_override = load("res://3dassets/envi/props/firewall/material/firewall_base_shadow.tres")
	
	#setup timer & offset
	timer.set_wait_time(offset)
	timer.start()
	timer.set_wait_time(wait_time)

# Mainin animasi tiap timer timeout
func _on_timer_timeout():
	
	#lantainya warm up
	anim_player.play("warm up")
	await anim_player.animation_finished
	#print("warmup1 done")
	onfire = true
	
	#fire on
	anim_player.set_speed_scale(fire_speed)
	anim_player.play("fire on")
	await anim_player.animation_finished
	#print("fire done")
	onfire = false
	
	#warm down
	anim_player.set_speed_scale(warmup_speed)
	anim_player.play_backwards("warm up")
	await anim_player.animation_finished
	#print("warmup2 done")
	
	#start recount
	timer.start()

# cek mati apa gk si pemain
func _check_for_kill():
	if onfire:
		return true

func _on_area_3d_body_entered(body):
	if(body is Player):
		get_parent().get_parent().audio_manager.firewall.play(0.0)
		await get_tree().create_timer(0.15).timeout
		get_parent().get_parent().audio_manager.firewall.stop()
		GlobalEvent.emit_signal("player_is_dead")
		#print("player has entered fire, hrsnya ded")
