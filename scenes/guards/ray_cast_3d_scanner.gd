extends RayCast3D
var target: Player = null

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 2.0
var angle_between_rays := deg_to_rad(5.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = true
	#generate_raycasts()

#func generate_raycasts() -> void:
	#print("RAYCASTS GENERATED")
	#var ray_count := angle_cone_of_vision / angle_between_rays
	#
	#for index in ray_count:
		#var ray := RayCast3D.new()
		#var angle := angle_between_rays * (index - ray_count / 2.0)
		#ray.cast_to = Vector3.FORWARD.rotated(Vector3.UP,angle) * max_view_distance
		#add_child(ray)
		#ray.enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#for ray in get_children():
		#if ray.is_colliding() and get_collider() is Player:
			#target = get_collider()
			#break
	
	var cast_count := int(angle_cone_of_vision /  angle_between_rays) + 1
	for index in cast_count:
		var cast_vector := (
			max_view_distance
			* Vector3.MODEL_FRONT.rotated(Vector3.UP, angle_between_rays * (index - cast_count / 2.0))
		)
		
		target_position  = cast_vector
		force_raycast_update()
		if is_colliding() and get_collider() is Player:
			#print("Guard Raycast Found A Player")
			var idle_state = get_parent().get_parent().get_parent().get_parent().get_node("states/idle")
			if idle_state:
				idle_state.chase_using_raycast()
				pass
			#target = get_collider() 
			break
	var does_see_player := target != null
	
	#if is_colliding():
		#print("RAYCAST COLLISION =", get_collider())
		#if get_collider() is Player:
			#print("Guard Raycast Found A Player")
			#var idle_state = get_parent().get_node("states/idle")
			#if idle_state:
				#idle_state.chase_using_raycast()
			
