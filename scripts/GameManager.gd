extends Node

var player_chased = false

var anon_status = ["-","-",'-','-']
var best_time = ["-","-","-",'-']
var level_unlocked = [true, false,false, false]
var level_finished = [true, false, false, false]

var current_save_id :=0
var player_name := ""

const _SAVE_PATH = "res://saves/"

const LEVEL_INFO = {
	1:{"title":"WAITLIST GENERAL", "color":"FF62D2"},
	2:{"title":"DEBITUS BANK", "color":"FFA360"},
	3:{"title":"DEBITUS BANK", "color":"3FCAA0"},
	4:{'title':'SHADOW CORP', 'color':'7350FF'}
}

# Simpen info ke file
func save_file():
	var file = FileAccess.open(_SAVE_PATH+str(current_save_id)+".txt", FileAccess.WRITE)
	var data : Dictionary = {
		"anon_status" : anon_status,
		"best_time" : best_time,
		"level_unlocked" : level_unlocked,
		"level_finished" : level_finished,
		"player_name":player_name
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

# Intantiate save file baru
func create_new_save_file(id):
	print(_SAVE_PATH+str(id)+".txt")
	var file = FileAccess.open(_SAVE_PATH+str(id)+".txt", FileAccess.WRITE)
	var data : Dictionary = {
		"anon_status" : ["-","-","-",'-'],
		"best_time" : ["-","-","-",'-'],
		"level_unlocked" : [true, false,false, false],
		"level_finished" : [false,false,false,false],
		"player_name": "player_name"
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

# Dapetin informasi dari savefile yang ada
func load_file_info(id):
	var TARGET_PATH = _SAVE_PATH+str(id)+".txt"
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

# Load save file yang dipilih
func load_file(id_selected):
	var TARGET_PATH = _SAVE_PATH+str(id_selected)+".txt"
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
