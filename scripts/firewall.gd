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

# Mainin animasi tiap timer timeout
func _on_timer_timeout():
	onfire = true
	anim_player.play("fire_on")
	await anim_player.animation_finished
	onfire = false
	timer.start()

# saat player masuk ke firewall
func _on_firewall_aoe_body_entered(body):
	var player_is_dead = _check_for_kill()
	GlobalEvent.emit_signal("player_is_dead")

# cek mati apa gk si pemain
func _check_for_kill():
	if onfire:
		return true
