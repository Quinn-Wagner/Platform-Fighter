extends "state.gd"

var dash_direction = Vector2.ZERO
var dash_speed = 400
var dashing = false

@export var dash_duration = .2
@onready var DashDuration_timer = $DashDuration

func update(delta):
	if !dashing and !Player.is_on_floor():
		return STATES.FALL
	if !dashing and Player.is_on_floor():
		return STATES.IDLE
	return null

func enter_state():
	play_animation('dash')
	Player.can_dash = false
	dashing = true
	DashDuration_timer.start(dash_duration)
	if Player.movement_input != Vector2.ZERO:
		dash_direction = Player.movement_input
	else:
		dash_direction = Player.last_direction
	Player.velocity = dash_direction.normalized() * dash_speed # Normalized to handle diagonal movements

func _on_timer_timeout():
	dashing = false
	
	
	
