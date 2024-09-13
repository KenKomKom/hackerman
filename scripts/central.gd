extends Area3D

class_name Central

@export var enemy_array: Array[Enemy] = []

func _ready():
	#Tries to subscribe registered enemies to Central
	#for enemy in enemy_array:
		#enemy.subscribe_to_central(self)
	pass
	

func _on_body_entered(body):
	#TODO: Mini-Game hack hivemin(?)
	if body is Player : return
	
	#unsub
	delete_central_func()
	#delete node - TEMP
	queue_free()
	

# Send Signal ke robot di array lokasi terakhir player
func send_alert_signal():
	# Tries to Send Alerted signal to all registered enemies in array
	# ini agak wacky karena selalu triggered di array idx 0
	print("Send Alerted Signal!")
	for enemy in enemy_array:
		if(enemy.current_state.name == "chasing"): 
			continue
		#TODO: Gantiin ini ke enemy-ny ke last know position dari player
		enemy.change_current_state(enemy.current_state.next_state[0])

# Run ketika central rusak
func delete_central_func():
	for enemy in enemy_array:
		enemy.unsubscribe_to_central()
