extends "state.gd"

var wall_jump_lock = true
var manipulate_jump = false

func update(delta):
	Player.gravity(delta)
	if !wall_jump_lock:
		player_movement()
	
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() == Vector2.RIGHT or Player.get_next_to_wall() == Vector2.LEFT:
		if STATES.SLIDE.climbing == false:
			return STATES.SLIDE
	if Player.jump_input_actuation and Player.can_double_jump:
		Player.can_double_jump = false
		return STATES.JUMP
	return null

func enter_state():
	wall_jump_lock = false
	manipulate_jump = false
	if Player.prev_state == STATES.JUMP or Player.prev_state == STATES.FALL and !Player.can_jump:
		play_animation('jump_double')
		Player.velocity.y = Player.DOUBLE_JUMP_VELOCITY
		Player.can_double_jump = false
	
	elif Player.prev_state == STATES.SLIDE:
		if STATES.SLIDE.climbing:
			wall_jump_lock = true
			manipulate_jump = true
			Player.velocity.y = Player.JUMP_VELOCITY / 3
			Player.velocity.x = STATES.SLIDE.last_wall_on.x * Player.SPEED / 2
			play_animation('jump')
			Player.can_double_jump = true
		else:
			wall_jump_lock = true
			play_animation('jump')
			Player.velocity.y = Player.JUMP_VELOCITY
			Player.can_double_jump = true
			Player.velocity.x = STATES.SLIDE.last_wall_on.x * -1 * Player.SPEED
			if STATES.SLIDE.last_wall_on.x > 0:
				Player.animated_sprite.scale.x = -1
			else:
				Player.animated_sprite.scale.x = 1
	else:
		if manipulate_jump == false:
			play_animation('jump')
			Player.velocity.y = Player.JUMP_VELOCITY
			Player.can_double_jump = true
