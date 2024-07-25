extends Area3D

class_name Central

@export var enemy_array: Array[Enemy] = []
@export var player : Node3D
	
func _ready():
	#Tries to subscribe registered enemies to Central
	for enemy in enemy_array:
		enemy.subscribe_to_central(self)
	

func _on_body_entered(body):
	#TODO: Mini-Game hack hivemin(?)
	if(player.name != body.name): return
	
	#unsub
	delete_central_func()
	#delete node - TEMP
	queue_free()
	

func send_alert_signal():
	# Tries to Send Alerted signal to all registered enemies in array
	# ini agak wacky karena selalu triggered di array idx 0
	print("Send Alerted Signal!")
	for enemy in enemy_array:
		if(enemy.current_state.name == "chasing"): 
			continue
		#TODO: Gantiin ini ke enemy-ny ke last know position dari player
		enemy.change_current_state(enemy.current_state.next_target[0])


func delete_central_func():
	for enemy in enemy_array:
		enemy.unsubscribe_to_central()
