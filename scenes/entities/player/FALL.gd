extends "state.gd"

@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = .2

func update(delta):
	play_animation('fall')
	Player.gravity(delta)
	player_movement()
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() == Vector2.RIGHT or Player.get_next_to_wall() == Vector2.LEFT:
		return STATES.SLIDE
	if Player.jump_input_actuation and Player.can_jump:
		return STATES.JUMP
	if Player.jump_input_actuation and Player.prev_state == STATES.JUMP and Player.can_double_jump:
		return STATES.JUMP
	return null

func enter_state():
	if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE or Player.prev_state == STATES.SLIDE:
		Player.can_jump = true
		CoyoteTimer.start(coyote_duration)
	elif Player.prev_state == STATES.JUMP:
		CoyoteTimer.start(coyote_duration)
	else: 
		Player.can_jump = false

func _on_coyote_timer_timeout():
	Player.can_jump = false
	
