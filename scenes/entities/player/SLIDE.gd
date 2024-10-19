extends "state.gd"

@export var climb_speed = 50
@export var slide_friction = .7
@export var mantle_speed = 300

var last_wall_on = Vector2.RIGHT
var climbing = false

func update(delta):
	slide_movement(delta)
	if Player.get_next_to_wall() == null:
		if Player.climb_input and Player.movement_input.y < 0:
			return STATES.JUMP
		return STATES.FALL
	if Player.jump_input_actuation:
		return STATES.JUMP
	if Player.is_on_floor():
		return STATES.IDLE
	return null

func slide_movement(delta):
	if Player.climb_input:
		climbing = true
		Player.movement_input.x = 0
		if Player.movement_input.y < 0:
			play_animation('climb')
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			play_animation('climb')
			Player.velocity.y = climb_speed
		else:
			play_animation('climb_static')
			Player.velocity.y = 0
	else:
		player_movement()
		Player.gravity(delta)
		climbing = false
		play_animation('wall_slide')
		Player.velocity.y *= slide_friction

func enter_state():
	play_animation('wall_slide')
	last_wall_on = Player.get_next_to_wall()
	climbing = false

