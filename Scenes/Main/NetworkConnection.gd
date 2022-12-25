extends Node

var player_state_collection = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	StartServer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func StartServer():
#changed from godot 3.x, used to be NetworkedMultiplayerEnet
	var server : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var gateway := SceneMultiplayer.new()
	
	#create server on specified port
	server.create_server(9999, 32)
	get_tree().set_multiplayer(gateway, self.get_path())
	multiplayer.set_multiplayer_peer(server)
	print("Server started")
	
	server.peer_connected.connect(self._Peer_Connected)
	server.peer_disconnected.connect(self._Peer_Disconnected)
	print(get_tree().get_multiplayer().get_unique_id())
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")
	await get_tree().create_timer(1).timeout
	print("timeout complete, spawning player")
	rpc("spawn_peer", player_id)
	for peer in player_state_collection:
		rpc_id(player_id, "spawn_peer", peer)
		
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")
	player_state_collection.erase(player_id)
	#unique network id for server is 0
	
@rpc func SendPlayerState(player_state):
	pass

@rpc(any_peer)
func RecievePlayerState(player_state):
	var player_id = multiplayer.get_remote_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		player_state_collection[player_id] = player_state

@rpc func SendWorldState(world_state):
	rpc("RecieveWorldState", world_state)
		
@rpc(any_peer)
func FetchPlayerData(requester_id):
	print("recieved request from player " + str(requester_id) + " for PlayerData")
	var player_id = multiplayer.get_remote_sender_id()
	print("remote sender id is " + str(multiplayer.get_remote_sender_id()))
	var data = ServerData.player_data
	rpc_id(player_id, "ReturnPlayerData", data)
	print("Sent PlayerData to player")

@rpc(any_peer)
func ReturnPlayerData(data):
	print(data.stringify())	

@rpc
func spawn_peer(player_id):
	print("adding peer")

@rpc
func RecieveWorldState(world_state):
	pass
