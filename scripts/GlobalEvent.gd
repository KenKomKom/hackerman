extends Node

signal level_start()
signal level_completed()

signal start_dialogue(file_path)
signal end_dialogue

signal player_move(dir)
signal player_is_hacking(node)
signal player_hacking_done()
signal database_download_finish()
signal player_is_dead()

# Global variables to track the checkpoint state
var checkpoint_reached = false
var database_downloaded = false
var is_hacking = false
var stop_for_dialogue = false
var banner_activated = false

var current_level: int = 1
var player_name: String = "Joni"
