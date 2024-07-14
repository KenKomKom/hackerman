extends CanvasLayer

@onready var textbox = $textbox

func _ready():
	GlobalEvent.connect("start_dialogue",load_dialog)

func load_dialog(file_path, player_name="Joni"):
	textbox.visible=true
	
	if FileAccess.file_exists(file_path):
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		
		if parsedFile is Array:
			for line in parsedFile:
				line["dialogue"] = line["dialogue"].replace("{nama}", player_name)
				line["dialogue"] = fix_length(line["dialogue"])
				textbox.display_line(line["nama"], line["dialogue"], line["emosi"])
				await textbox.go_to_next_line
			textbox.visible=false
			GlobalEvent.emit_signal("end_dialogue")
		else:
			print("error")
			print(parsedFile)
	else:
		print("file not exists")

func fix_length(string : String):
	var start=0
	var split=false
	while not split:
		if (len(string)-start)>50:
			var break_position = string.findn(" ", start+40)
			if break_position-start>50:
				break_position=start+45
				string = string.substr(0, break_position)+"-\n"+string.substr(break_position,len(string))
				start=break_position+2
			else:
				string[break_position] = "\n"
				start=break_position+1
		else:
			split=true
	return string
