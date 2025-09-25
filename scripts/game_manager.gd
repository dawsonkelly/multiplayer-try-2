extends Node

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server")
		%NetworkManager.become_host()

func become_host():
	%MultiplayerHud.hide()
	%SteamHud.hide()
	%NetworkManager.become_host()

func join_as_client():
	%MultiplayerHud.hide()
	%SteamHud.hide()
	%NetworkManager.join_as_client()

func use_steam():
	%MultiplayerHud.hide()
	%SteamHud.show()
	print("Using Steam")
	SteamManager.initialize_steam()
	%NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM

func list_steam_lobbies():
	print("List steam lobbies")
	%NetworkManager.list_steam_lobbies()
	
