extends Node2D
class_name Level


@export var enemies: Node2D
@export var goal: Goal

@onready var player: Player = $Player

signal spotted
signal level_finished

func _ready() -> void:
	goal.level_finished.connect(repeat_level_finished)
	
	player.abducted.connect(abduct_enemy)
	
	var enemies_children = enemies.get_children()
	for enemy: Enemy in enemies_children:
		enemy.spotted.connect(repeat_spotted)


func abduct_enemy(target: Enemy) -> void:
	enemies.remove_child(target)


func repeat_spotted():
	spotted.emit()

func repeat_level_finished():
	level_finished.emit()
