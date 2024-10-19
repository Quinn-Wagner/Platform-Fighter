extends "state.gd"

var crouch_idle = false
var crouch_move = false

func update(delta):
	crouch_movement()
	Player.gravity(delta)
	if !Player.crouch_input and crouch_move:
		return STATES.MOVE
	if !Player.crouch_input and crouch_idle:
		return STATES.IDLE
	if Player.attack_input:
		return STATES.ATTACK
	return null

func enter_state():
	Player.collision_shape.shape = Player.crouch_hitbox
	Player.collision_shape.position.y = 9
	if Player.prev_state == STATES.MOVE:
		play_animation('move_crouch')
		crouch_idle = false
		crouch_move = true
	else:
		play_animation('idle_crouch')
		crouch_move = false
		crouch_idle = true
	Player.can_dash = false
