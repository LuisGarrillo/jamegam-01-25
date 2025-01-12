extends CharacterBody2D
class_name Enemy
@onready var notice_cooldown: Timer = $Timers/NoticeCooldown
@onready var action_timer: Timer = $Timers/ActionTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var view_field: Area2D = $ViewField

@export var view_rotation: int = 0
@export var is_target: bool = false
@export var action_duration: int = 1
@export var action: String = ""
var notice_time := 1.0
var aux_action: String = ""
var directions = {
	"0": "down",
	"90": "left",
	"180": "up",
	"270": "right"	
}
signal spotted


func _ready() -> void:
	aux_action = action
	view_field.rotation_degrees = view_rotation
	animated_sprite_2d.play("idle-" + directions[String.num_int64(view_field.rotation_degrees)])
	action_timer.wait_time = action_duration
	action_timer.start()

func perform_action() -> void:
	if action == "turn":
		turn(180, 0)

func turn(rotation_deg: int, direction) -> void:
	view_field.rotation_degrees = view_field.rotation_degrees + rotation_deg if (view_field.rotation_degrees + rotation_deg) < 360 else view_field.rotation_degrees - rotation_deg
	animated_sprite_2d.play("idle-" + directions[String.num_int64(view_field.rotation_degrees)])
	

func is_blocked(target_position: Vector2) -> bool:
	var space = get_world_2d().direct_space_state
	var ray_query = PhysicsRayQueryParameters2D.create(global_position, target_position)
	ray_query.exclude = [self]
	var result = space.intersect_ray(ray_query)
	
	return not result["collider"] is Player 

func on_player_entered(body: Player) -> void:
	if not body:
		return
	
	if is_blocked(body.global_position):
		return
	
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
