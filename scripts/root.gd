extends Control

@onready var ui_display: UiDisplay = $UiDisplay

@onready var level_scenes = [
	preload("res://scenes/game/level.tscn")
]
@onready var game_display: CanvasLayer = $GameDisplay
var level: Level
var current_level = 0
var pausable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_UiDisplay()

func set_up_UiDisplay() -> void:
	ui_display.start_game.connect(start_game)
	ui_display.next_level.connect(advance_level)
	ui_display.to_title.connect(to_tile)
	
	ui_display.transition_finished.connect(transition_finished)


func start_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	ui_display.unload_title()
	set_up_level()
	ui_display.finish_transition()


func set_up_level() -> void:
	level = level_scenes[current_level].instantiate()
	level.tutorial.connect(ui_display.tutorial.set_message)
	level.spotted.connect(reset)
	level.level_finished.connect(ui_display.start_transition)
	game_display.add_child(level)


func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused


func transition_finished() -> void:
	if level in game_display.get_children():
		pausable = true

func to_tile() -> void:
	remove_child(level)

func reset() -> void:
	game_display.remove_child(level)
	set_up_level()
	

func advance_level() -> void:
	pausable = false
	current_level += 1
	if current_level == len(level_scenes):
		finish_game()
		return
	
	reset()

func finish_game() -> void:
	get_tree().quit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset-debug") and level in game_display.get_children():
		reset()
	if Input.is_action_just_pressed("pause") and pausable:
		toggle_pause()
		ui_display.toggle_pause()
