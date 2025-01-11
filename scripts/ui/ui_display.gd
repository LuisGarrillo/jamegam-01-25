extends CanvasLayer
class_name UiDisplay

@onready var title: Control = $Title
@onready var transition_holder: AnimatedSprite2D = $TransitionHolder
@onready var tutorial: Tutorial = $Tutorial

const PAUSE = preload("res://scenes/ui/pause.tscn")
var pause

var current_step : String
var to

signal start_game
signal next_level
signal to_title
var destination: Dictionary = {
	"game": start_game,
	"level": next_level,
	"title": to_title
}
signal transition_finished


func _ready():
	pause = PAUSE.instantiate()


func start_transition(new_to) -> void:
	to = new_to
	current_step = "in"
	transition(current_step)


func transition(step: String) -> void:
	transition_holder.play(step)


func finish_transition() -> void:
	current_step = "out"
	transition(current_step)


func unload_title() -> void:
	remove_child(title)


func load_title() -> void:
	add_child(title)

func toggle_pause() -> void:
	add_child(pause) if not pause in get_children() else remove_child(pause)

func _on_transition_holder_animation_finished() -> void:
	if current_step == "in":
		destination[to].emit()
	else:
		transition_finished.emit()
	
