extends Node3D

func make_visible_on_zoom_out(status):
	$"shield body".set_layer_mask_value(1,status)
