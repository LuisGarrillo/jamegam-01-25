extends Node2D
class_name Level


@export var enemies: Node2D
@export var target: Enemy
@export var goal: Goal

@onready var player: Player = $Player
@onready var target_focus: Timer = $Node/TargetFocus
@onready var camera_2d: LevelCamera = $Camera2D

signal spotted
signal level_finished

func _ready() -> void:
	goal.level_finished.connect(repeat_level_finished)
	
	player.abducted.connect(abduct_enemy)
	
	var enemies_children = enemies.get_children()
	for enemy: Enemy in enemies_children:
		enemy.spotted.connect(repeat_spotted)
	
	camera_2d.switch_to(target.global_position)
	target_focus.start()


func abduct_enemy() -> void:
	enemies.remove_child(target)


func repeat_spotted():
	spotted.emit()

func repeat_level_finished():
	level_finished.emit()


func _on_target_focus_timeout() -> void:
	camera_2d.position_smoothing_enabled = true
	camera_2d.position_smoothing_speed = 10
	camera_2d.switch_to_player()
	player.on_control = true
	
