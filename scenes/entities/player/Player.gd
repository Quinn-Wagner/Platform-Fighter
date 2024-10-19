extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# sprites/animations
@onready var animated_sprite = $AnimatedSprite2D
var anim_state_machine

# hitboxes
@onready var collision_shape = $CollisionShape2D
var default_hitbox = preload('res://resources/default_hitbox.tres')
var crouch_hitbox =  preload('res://resources/crouch_hitbox.tres')

@onready var punch_hitbox = $AnimatedSprite2D/Punch
@onready var kick_hitbox = $AnimatedSprite2D/Kick

#player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false 
var dash_input = false
var crouch_input = false
var attack_input = false
var allow_input = true

#player movement
const SPEED = 150.0
const CROUCH_SPEED = 80.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -300.0
var last_direction = Vector2.RIGHT

#player stats
var hp = 500
var punch1_damage = 25
var punch2_damage = 30
var low_kick_damage = 40
var damaged = false

#mechanics
var can_attack = true
var can_dash = true
var can_jump = true
var can_double_jump = false

#states
var current_state = null
var prev_state = null

#nodes
@onready var STATES = $STATES
@onready var Raycasts = $Raycasts

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		
		if allow_input:
			player_input()
		
		move_and_slide()
		change_state(current_state.update(delta))
		$Label.text = str(current_state.get_name())
		anim_state_machine = $AnimationTree.get('parameters/playback')
	
func gravity(delta):
	if !is_on_floor():
		velocity.y += gravity_value * delta
		
# Allows for changing between states
func change_state(input_state):
	if input_state != null:
		prev_state = current_state 
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state()
		
func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update() 
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT

func player_input():
	movement_input = Vector2.ZERO  # Reset input
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1

	# jumps
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else: 
		jump_input = false
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else: 
		jump_input_actuation = false
		
	#climb
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else: 
		climb_input = false
		
	#dash
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false
			
	#crouch
	if Input.is_action_pressed("Crouch"):
		crouch_input = true
	else: 
		crouch_input = false

	#attack
	if Input.is_action_just_pressed("Attack"):
		attack_input = true
	else: 
		attack_input = false
