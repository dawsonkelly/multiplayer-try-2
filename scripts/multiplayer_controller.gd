extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const PUSH_FORCE = 80.0

#@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bomb = preload("res://scenes/bomb.tscn")

var _bomb_spawnpoint

var direction = 1
var do_jump = false
var _is_on_floor = true
var alive = true
var drop_bomb = false

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

func _ready() -> void:
	if multiplayer.get_unique_id() == player_id:
		%Camera2D.make_current()
	else:
		%Camera2D.enabled = false
	
	_bomb_spawnpoint = self.get_node("BombSpawnPoint")
	print(_bomb_spawnpoint)

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
	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)

func _physics_process(delta):
	if multiplayer.is_server():
		#if not alive && is_on_floor():
		#	_set_alive()
		
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)
		
		if drop_bomb:
			spawn_bomb()
			drop_bomb = false
		
	#if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
	#	_apply_animations(delta)

func spawn_bomb():
	print("player %s dropping bomb" % player_id)
	
	var bomb_to_add = bomb.instantiate()
	
	_bomb_spawnpoint.add_child(bomb_to_add, true)
