extends Control
@onready var level_scenes = [
	preload("res://scenes/game/level.tscn")
]
@onready var game_display: CanvasLayer = $GameDisplay
var level: Level
var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_up_level()

func set_up_level() -> void:
	level = level_scenes[current_level].instantiate()
	level.spotted.connect(reset)
	level.level_finished.connect(advance_level)
	game_display.add_child(level)


func reset() -> void:
	game_display.remove_child(level)
	set_up_level()
	

func advance_level() -> void:
	current_level += 1
	if current_level == len(level_scenes):
		finish_game()
		return
	
	reset()

func finish_game() -> void:
	get_tree().quit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset-debug"):
		reset()
		
