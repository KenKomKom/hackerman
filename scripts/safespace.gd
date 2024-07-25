extends StaticBody3D

class_name SafeSpace

var tile_size = 1

func _ready():
	print("a")
	position.x = position.snapped(Vector3.ONE * tile_size).x
	position.z = position.snapped(Vector3.ONE * tile_size).z
	position += Vector3(1,0,1) * tile_size / 2
