extends "state.gd"

func update(delta):
	Player.velocity.x = 0
	Player.gravity(delta)
	
func enter_state():
	play_animation('dead')
