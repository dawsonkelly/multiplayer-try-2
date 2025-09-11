extends MultiplayerSynchronizer

var input_direction

@onready var player = $".."

func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	
	input_direction = Input.get_axis("move_left", "move_right")
	

func _physics_process(delta):
	input_direction = Input.get_axis("move_left", "move_right")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump.rpc()#here is how you call an rpc function
	if Input.is_action_just_pressed("bomb"):
		bomb.rpc()

@rpc("call_local")#rpcs are functions that allow client and server to talk to each other
func jump():
	if multiplayer.is_server():
		player.do_jump = true

@rpc("call_local")
func bomb():
	if multiplayer.is_server():
		player.drop_bomb = true
