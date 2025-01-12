extends CharacterBody2D
class_name Player

@onready var hat_sprites: AnimatedSprite2D = $hatSprites
@onready var human_sprites: AnimatedSprite2D = $humanSprites
@onready var hat_shape: CollisionShape2D = $hatShape
@onready var human_shape: CollisionShape2D = $humanShape
@onready var walk_audio: AudioStreamPlayer = $"Walk audio"


const SPEED = 400
const DESACCELERATION = 75
const SPEEDCAPS : Dictionary = {
	"hat": 175,
	"human": 75
}
var on_control: bool = false
var direction: Array = [0, 0]
var aim: String = "down"
var form = "hat"
var can_abduct: bool = false
var target: Enemy

var tutorial_abduct_emitted = false
signal abducted
signal tutorial_abduct

func _physics_process(delta: float) -> void:
	updateDefault(delta)
	if on_control:
		check_input()

func update_anims():
	var anim_action = "idle" if velocity.x == 0 and velocity.y == 0 else "walk"
	if form == "hat":
		hat_sprites.play(anim_action)
	if form == "human":
		if abs(velocity.y) > abs(velocity.x):
			aim = "down" if velocity.y > 0 else "up"
		elif abs(velocity.y) < abs(velocity.x):
			aim = "right" if velocity.x > 0 else "left"
		human_sprites.play(anim_action + "-" + aim)
	
	if anim_action == "walk":
		walk_audio.play()
	else:
		walk_audio.play()
		
	
func check_input() -> void:
	direction[0] = Input.get_axis("left", "right")
	direction[1] = Input.get_axis("up", "down")
	
	if Input.is_action_just_pressed("abduct"):
		abduct()
	
	
func updateDefault(delta) -> void:
	velocity.x = get_velocity_variation(velocity.x, direction[0], delta) if direction[0] else move_toward(velocity.x, 0, DESACCELERATION)
	velocity.y = get_velocity_variation(velocity.y, direction[1], delta) if direction[1] else move_toward(velocity.y, 0, DESACCELERATION)
	update_anims()
	move_and_slide()

func get_velocity_variation(velocityAxis, direction, delta) -> float:
	return min(velocityAxis + direction * SPEED * delta, SPEEDCAPS[form]) if direction > 0 else max(velocityAxis + direction * SPEED * delta, SPEEDCAPS[form] * direction) 

# Action methods

func abduct() -> void:
	if not can_abduct:
		return
	hat_sprites.visible = false
	hat_shape.disabled = true
	
	human_sprites.visible = true
	human_shape.disabled = false
	
	form = "human"
	abducted.emit()

# signals

func on_enemy_close(body: Enemy) -> void:
	if not body:
		return
	
	if not body.is_target:
		return
	
	target = body
	can_abduct = true
	if not tutorial_abduct_emitted:
		tutorial_abduct_emitted = true
		tutorial_abduct.emit()
	


func on_enemy_far(body: Enemy) -> void:
	if not body:
		return
		
	if not body.is_target:
		return
		
	can_abduct = false
