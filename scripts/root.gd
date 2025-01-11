extends Control

@onready var ui_display: UiDisplay = $UiDisplay

@onready var level_scenes = [
	preload("res://scenes/game/level.tscn")
]
@onready var game_display: CanvasLayer = $GameDisplay
var level: Level
var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_UiDisplay()

func set_up_UiDisplay() -> void:
	ui_display.start_game.connect(start_game)
	ui_display.next_level.connect(advance_level)
	ui_display.to_title.connect(to_tile)


func start_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	ui_display.unload_title()
	set_up_level()
	ui_display.finish_transition()


func set_up_level() -> void:
	level = level_scenes[current_level].instantiate()
	level.spotted.connect(reset)
	level.level_finished.connect(ui_display.start_transition)
	game_display.add_child(level)


func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused


func to_tile() -> void:
	remove_child(level)

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
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		ui_display.pause()
