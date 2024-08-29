extends enemy_state

class_name enemy_idle_state

var point_A : Vector3
var point_B : Vector3
var current_target : Vector3
var moving : bool = false

func _ready():
	# Initialize points A and B (replace with desired coordinates)
	point_A = Vector3(3, -1, 2) # Example coordinates for point A
	point_B = Vector3(3, -1, -4) # Example coordinates for point B
	
	# Set initial target to point A
	current_target = point_A
	#moving = true
	print("Patrolling between points A and B")
	print("Parent Enemy Movement Speed", parent_enemy.movement_speed)

func ready_state():
	# Reset moving status and set the target
	#moving = true
	print("Patrolling between points A and B")

func do_something(delta):
	if moving:
		# Move the enemy towards the current target position
		#parent_enemy.global_position = lerp(parent_enemy.global_position, current_target, parent_enemy.movement_speed * delta)
		
		var direction = (current_target - parent_enemy.global_position).normalized()
		
		# Move enemy towards the target position at a constant speed
		parent_enemy.global_position += direction * parent_enemy.movement_speed * 0.1
		
		#print("Distance : ",(parent_enemy.global_position - current_target).length())
		# Check if the enemy is close enough to the target position
		if (parent_enemy.global_position - current_target).length() < 0.08:
			print("Switch target point")
			if current_target == point_A:
				current_target = point_B
			else:
				current_target = point_A

	# Optional: Update state if needed
	if (parent_enemy.movement_target_position - parent_enemy.global_position).length() < 0:
		parent_enemy.change_current_state(next_target[0])
		
		# Tries to warn other hive if this enemy is connected to the central
		var central = parent_enemy.central
		if central:
			central.send_alert_signal()

func chase_using_raycast():
	#print("FUNCTION CALLED WITH RAYCAST")
	#if (parent_enemy.movement_target_position - parent_enemy.global_position).length() < 4:
	parent_enemy.change_current_state(next_target[0])
