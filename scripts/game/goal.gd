extends Area2D
class_name Goal

signal level_finished

func _on_body_entered(body: Player) -> void:
	if body.form == "human":
		level_finished.emit()
