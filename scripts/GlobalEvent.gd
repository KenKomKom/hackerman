extends Node

signal level_start(level_name, level_id, level_color)

signal start_dialogue(file_path)
signal end_dialogue

signal player_move(dir)
signal player_is_hacking(node)
signal player_hacking_done()
signal player_is_dead()

# Global variables to track the checkpoint state
var checkpoint_reached = false
var database_downloaded = false
var is_hacking = false
var hacked_enemy: Enemy = null
