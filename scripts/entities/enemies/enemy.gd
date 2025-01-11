extends CharacterBody2D
class_name Enemy
@onready var notice_cooldown: Timer = $Timers/NoticeCooldown
@onready var action_timer: Timer = $Timers/ActionTimer

@onready var view_field: Area2D = $ViewField

@export var view_rotation: int = 0
@export var is_target: bool = false
@export var action_duration: int = 1
@export var action: String = ""
var notice_time := 1.0
var aux_action: String = ""
signal spotted


func _ready() -> void:
	view_field.rotation_degrees = view_rotation
	action_timer.start()

func perform_action() -> void:
	if action == "turn":
		turn(180, 0)

func turn(rotation_deg: int, direction) -> void:
	rotation_degrees += rotation_deg

func on_player_entered(body: Player) -> void:
	if not body:
		return
	
	aux_action = action
	action = ""
	notice_cooldown.start()


func on_player_exited(body: Player) -> void:
	if not body:
		return
	action = aux_action
	notice_cooldown.stop()


func on_spotted() -> void:
	spotted.emit()


func _on_action_timer_timeout() -> void:
	perform_action()
	action_timer.start()
