extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

#@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1
var do_jump = false
var _is_on_floor = true
var alive = true

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

#func _apply_animations(delta):
	## Flip the Sprite
	#if direction > 0:
		#animated_sprite.flip_h = false
	#elif direction < 0:d
		#animated_sprite.flip_h = true
	#
	## Play animations
	#if _is_on_floor:
		#if direction == 0:
			#animated_sprite.play("idle")
		#else:
			#animated_sprite.play("run")
	#else:
		#animated_sprite.play("jump")
#
@warning_ignore("unused_parameter")
func _apply_movement_from_input(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		do_jump = false

	# Get the input direction: -1, 0, 1
	direction = %InputSynchronizer.input_direction
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _physics_process(delta):
	if multiplayer.is_server():
		#if not alive && is_on_floor():
		#	_set_alive()
		
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)
		
	#if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
	#	_apply_animations(delta)
