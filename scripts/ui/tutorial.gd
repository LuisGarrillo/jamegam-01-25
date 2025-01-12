extends Control
class_name Tutorial

@onready var instruction_label: Label = $ColorRect/InstructionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var messages = {
	"movement": "Move with AWSD keys!",
	"abduct": "Abduct them with J!",
	"goal": "Go back to where you started!"
}

func set_message(action) -> void:
	print("hi")
	instruction_label.text = messages[action]
	animation_player.play("in")
	

func out() -> void:
	animation_player.play("out")
