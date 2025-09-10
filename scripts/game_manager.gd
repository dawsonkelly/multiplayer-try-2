extends Node

func become_host():
	%MultiplayerHud.hide()
	MultiplayerManager.become_host()

func join_as_player_2():
	%MultiplayerHud.hide()
	MultiplayerManager.join_as_player_2()
