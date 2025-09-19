extends Node

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server")
		MultiplayerManager.become_host()
		

func become_host():
	%MultiplayerHud.hide()
	MultiplayerManager.become_host()

func join_as_player_2():
	%MultiplayerHud.hide()
	MultiplayerManager.join_as_player_2()
