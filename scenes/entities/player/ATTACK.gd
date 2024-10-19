extends "state.gd"

@onready var attack_timer = $AttackTimer

var attacking = false

var combo = false

var punch1_damage = 25
var punch2_damage = 30
var low_kick_damage = 35

var knockback = Vector2(1, -1)

func update(delta):
	Player.gravity(delta)
	Player.velocity.x = 0
	if !attacking:
		return STATES.MOVE
	if Player.attack_input and attacking and Player.prev_state != STATES.ATTACK and Player.prev_state != STATES.CROUCH:
		return STATES.ATTACK
	return null
	
func enter_state():
	attack_timer.start()
	attacking = true
	if Player.prev_state == STATES.ATTACK:
		combo = true
		play_animation('punch2')
	if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE:
		play_animation('punch1')
	if Player.prev_state == STATES.CROUCH:
		play_animation('kick')
	return null
	
func _on_attack_timer_timeout():
	attacking = false
	combo = false

func _on_punch_body_entered(body):
	$"../../AnimatedSprite2D/Punch/CollisionShape2D".disabled = false
	body.damaged = true
	if body.is_in_group('damageable'):
		if !combo:
			body.STATES.HIT.damage_taken = punch1_damage
			if body.last_direction == Vector2.RIGHT:
				body.velocity.x = -1 * knockback.x * 30
				body.velocity.y = 1 * knockback.y * 150
			else:
				body.velocity.x = 1 * knockback.x * 30
				body.velocity.y = 1 * knockback.y * 150
		else:
			body.STATES.HIT.damage_taken = punch2_damage
			if body.last_direction == Vector2.RIGHT:
				body.velocity.x = -1 * knockback.x * 50
				body.velocity.y = 1 * knockback.y * 150
			else:
				body.velocity.x = 1 * knockback.x * 50
				body.velocity.y = 1 * knockback.y * 150
		return null

func _on_kick_body_entered(body):
	$"../../AnimatedSprite2D/Kick/CollisionShape2D".disabled = false
	body.damaged = true
	if body.is_in_group('damageable'):
		body.STATES.HIT.damage_taken = low_kick_damage
		if body.last_direction == Vector2.RIGHT:
			body.velocity.x = -1 * knockback.x * 30
			body.velocity.y = 1 * knockback.y * 200
		else:
			body.velocity.x = 1 * knockback.x * 30
			body.velocity.y = 1 * knockback.y * 200
	return null

