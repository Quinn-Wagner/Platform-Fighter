extends "state.gd"


func update(delta):
	mantle_movement()
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Player.jump_input_actuation:
		return STATES.JUMP
	return null
	
func mantle_movement():
	var mantle_tween = create_tween()
	mantle_tween.tween_property(Player, 'position', Vector2(190,-290), 0.5)
	
func enter_state():
	play_animation('climb_mantle')
	Player.velocity.y = 0
