extends Control

signal start


func _on_start_pressed() -> void:
	start.emit("game")
