extends Node

signal player_move(dir)
signal start_dialogue(file_path)
signal end_dialogue
#signal level_start_prep()
signal level_start(level_name, level_id, level_color)
signal player_is_dead()

# Global variables to track the checkpoint state
var checkpoint_reached = false
