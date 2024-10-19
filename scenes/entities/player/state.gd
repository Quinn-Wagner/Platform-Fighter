extends Node

var STATES = null
var Player = null

func enter_state():
	pass
func exit_state():
	pass
func update(delta):
	return null

func player_movement():
	if Player.movement_input.x > 0:
		Player.velocity.x = Player.SPEED
		Player.animated_sprite.scale.x = 1
		Player.last_direction = Vector2.RIGHT
	elif Player.movement_input.x < 0:
		Player.velocity.x = - Player.SPEED
		Player.animated_sprite.scale.x = -1
		Player.last_direction = Vector2.LEFT
	else:
		Player.velocity.x = 0
		
func crouch_movement():
	if Player.movement_input.x > 0:
		play_animation('move_crouch')
		Player.velocity.x = Player.CROUCH_SPEED
		Player.animated_sprite.scale.x = 1
		Player.last_direction = Vector2.RIGHT
	elif Player.movement_input.x < 0:
		play_animation('move_crouch')
		Player.velocity.x = - Player.CROUCH_SPEED
		Player.animated_sprite.scale.x = -1
		Player.last_direction = Vector2.LEFT
	else:
		play_animation('idle_crouch')
		Player.velocity.x = 0

func play_animation(anim_name):
	Player.anim_state_machine.travel(anim_name)
