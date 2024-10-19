extends "state.gd"

var crouching = false

func update(delta):
	Player.gravity(delta)
	if Player.movement_input.x != 0:
		return STATES.MOVE
	if Player.jump_input_actuation:
		return STATES.JUMP
	if Player.velocity.y > 0:
		return STATES.FALL
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
	Player.velocity.x = 0
	Player.collision_shape.shape = Player.default_hitbox
	Player.collision_shape.position.y = 2
	play_animation('idle')
	Player.can_dash = true
