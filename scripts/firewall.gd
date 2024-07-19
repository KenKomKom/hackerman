extends MeshInstance3D

@export var tile_size :=1
@onready var fire_wall_aoe = $firewall_aoe
@onready var timer := $firewall_aoe/Timer
@onready var anim_player := $firewall_aoe/AnimationPlayer
var onfire := false

func _ready():
	position.x = position.snapped(Vector3.ONE * tile_size).x
	position.z = position.snapped(Vector3.ONE * tile_size).z
	position += Vector3(1,0,1) * tile_size / 2

func _on_timer_timeout():
	onfire = true
	anim_player.play("fire_on")
	var overlappings = fire_wall_aoe.get_overlapping_bodies()
	print(overlappings)
	if len(overlappings)!=0:
		check_for_kill()
	await anim_player.animation_finished
	onfire = false
	timer.start()

func _on_firewall_aoe_body_entered(body):
	check_for_kill()

func check_for_kill():
	if onfire: # TODO make legit dead cycle
		TransitionLayer.change_scene("res://scenes/main_menu.tscn")
