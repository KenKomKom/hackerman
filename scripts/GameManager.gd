extends Node

var player_chased = false

var anon_status = ["-","-",'-','-']
var best_time = ["-","-","-",'-']
var level_unlocked = [true, false,false, false]
var level_finished = [true, false, false, false]

var current_save_id :=0
var player_name := ""

const SAVE_PATH = "res://saves/"

func save_file():
	var file = FileAccess.open(SAVE_PATH+str(current_save_id)+".txt", FileAccess.WRITE)
	var data : Dictionary = {
		"anon_status" : anon_status,
		"best_time" : best_time,
		"level_unlocked" : level_unlocked,
		"level_finished" : level_finished,
		"player_name":player_name
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func create_new_save_file(id):
	print(SAVE_PATH+str(id)+".txt")
	var file = FileAccess.open(SAVE_PATH+str(id)+".txt", FileAccess.WRITE)
	var data : Dictionary = {
		"anon_status" : ["-","-","-",'-'],
		"best_time" : ["-","-","-",'-'],
		"level_unlocked" : [true, false,false, false],
		"level_finished" : [false,false,false,false],
		"player_name": "player_name"
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func load_file_info(id):
	var TARGET_PATH = SAVE_PATH+str(id)+".txt"
	var file = FileAccess.open(TARGET_PATH, FileAccess.READ)
	if FileAccess.file_exists(TARGET_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				return {
					"player_name" : current_line["player_name"],
					"level_finished" : current_line['level_finished'],
					"exist":true
				}
	return {
		"exist":false
	}

func load_file(id_selected):
	var TARGET_PATH = SAVE_PATH+str(id_selected)+".txt"
	var file = FileAccess.open(TARGET_PATH, FileAccess.READ)
	if FileAccess.file_exists(TARGET_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				anon_status = current_line['anon_status']
				best_time = current_line['best_time']
				level_unlocked = current_line['level_unlocked']
				player_name = current_line["player_name"]
				level_finished=current_line['level_finished']
				current_save_id = id_selected
			return true
	return false
