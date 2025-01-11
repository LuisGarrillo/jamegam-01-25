extends CharacterBody2D
class_name Player

const SPEED = 400
const DESACCELERATION = 75
const SPEEDCAPS : Dictionary = {
	"hat": 175,
	"human": 75
}
var on_control: bool = false
var direction: Array = [0, 0]
var aim: int = 1
var form = "hat"
var can_abduct: bool = false
var target: Enemy

signal abducted

func _physics_process(delta: float) -> void:
	updateDefault(delta)
	if on_control:
		check_input()
	
	
func check_input() -> void:
	direction[0] = Input.get_axis("left", "right")
	direction[1] = Input.get_axis("up", "down")
	
	if Input.is_action_just_pressed("abduct"):
		abduct()
	
	
func updateDefault(delta) -> void:
	velocity.x = get_velocity_variation(velocity.x, direction[0], delta) if direction[0] else move_toward(velocity.x, 0, DESACCELERATION)
	velocity.y = get_velocity_variation(velocity.y, direction[1], delta) if direction[1] else move_toward(velocity.y, 0, DESACCELERATION)
	
	move_and_slide()

func get_velocity_variation(velocityAxis, direction, delta) -> float:
	return min(velocityAxis + direction * SPEED * delta, SPEEDCAPS[form]) if direction > 0 else max(velocityAxis + direction * SPEED * delta, SPEEDCAPS[form] * direction) 

# Action methods

func abduct() -> void:
	if not can_abduct:
		return
	print("abducted")
	form = "human"
	abducted.emit(target)

# signals

func on_enemy_close(body: Enemy) -> void:
	if not body:
		return
	
	if not body.is_target:
		return
	
	target = body
	can_abduct = true
	


func on_enemy_far(body: Enemy) -> void:
	if not body:
		return
		
	if not body.is_target:
		return
		
	can_abduct = false
