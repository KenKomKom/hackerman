extends CanvasLayer

@onready var textbox = $textbox

func _ready():
	GlobalEvent.connect("start_dialogue", _load_dialog)
	#GlobalEvent.emit_signal("start_dialogue","res://dialogue/level 3/postgame.json")

# Masukin text ke dialog
func _load_dialog(file_path):
	textbox.visible=true
	if FileAccess.file_exists(file_path):
		var player_name = GlobalEvent.player_name
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		
		if parsedFile is Array:
			for line in parsedFile:
				print(line)
				line["dialogue"] = line["dialogue"].replace("{name}", player_name)
				
				#ubah warna, replace nama jadi hexcode
				line["dialogue"] = line["dialogue"].replace("[color=hackerman]", "[color=#80E6ED]")
				line["dialogue"] = line["dialogue"].replace("[color=shadow]", "[color=#D458FF]")
				if(line["nama"] == "h"): 
					line["dialogue"] = line["dialogue"].replace("[color=whisper]", "[color=#9D96FF]")
				else:
					line["dialogue"] = line["dialogue"].replace("[color=whisper]", "[color=#B274D7]")
				line["dialogue"] = line["dialogue"].replace("[color=hint]", "[color=#FFCF55]")
				line["dialogue"] = line["dialogue"].replace("[color=obstacle]", "[color=#FF5D97]")
				
				#line["dialogue"] = fix_length(line["dialogue"])
				textbox.display_line(line["nama"], line["dialogue"], line["emosi"])
				await textbox.go_to_next_line
			textbox.visible=false
			
			await get_tree().create_timer(0.15).timeout
			GlobalEvent.emit_signal("end_dialogue")
		else:
			print("error")
			print(parsedFile)
	else:
		print("file not exists")

# Betulin string biar gk bocor dari textbox
func _fix_length(string : String):
	var start=0
	var split=false
	while not split:
		if (len(string)-start)>50:
			var break_position = string.findn(" ", start+40)
			if break_position-start>50 or break_position==-1:
				break_position=start+45
				string = string.substr(0, break_position)+"-\n"+string.substr(break_position,len(string))
				start=break_position+2
			else:
				string[break_position] = "\n"
				start=break_position+1
		else:
			split=true
	return string
