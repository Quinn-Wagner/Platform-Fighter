extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement()
	if !Input.is_action_pressed("MoveRight") and !Input.is_action_pressed("MoveLeft"):
		return STATES.IDLE
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.jump_input_actuation:
		return STATES.JUMP
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.crouch_input:
		return STATES.CROUCH
	if Player.attack_input:
		return STATES.ATTACK
	if Player.damaged:
		return STATES.HIT
	return null

func enter_state():
	Player.collision_shape.shape = Player.default_hitbox
	Player.collision_shape.position.y = 2
	play_animation('move')
	Player.can_dash = true
	

