extends Camera2D
class_name LevelCamera

@export var player: Player
var following_player: bool = false
var target_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = player.global_position if following_player else target_position

func switch_to(new_target_position) -> void:
	target_position = new_target_position
	following_player = false
	
func switch_to_player() -> void:
	following_player = true
