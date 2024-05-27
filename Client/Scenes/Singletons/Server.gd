extends Node

#var network = ENetMultiplayerPeer.new()
var network = WebSocketMultiplayerPeer.new()
var ip = "127.0.0.1"

var port = 5000
var url = "ws://" + ip + ":" + str(port)

# Called when the node enters the scene tree for the first time.
func _ready():
	connectToServer()
	await get_tree().create_timer(1.0).timeout
	fetchLabyrinthSize("res://Client.tscn")
	pass # Replace with function body.

func _process(_delta):
	if (network.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED ||
	network.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING):
		network.poll();

func connectToServer():
	#network.create_client(ip, port)
	network.create_client(url)
	multiplayer.set_multiplayer_peer(network)
	#network.connect_to_url(url)
	
	print("client created")
	
	#https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html#class-multiplayerapi
	#  ^
	#  |
	#  |
	#in my professional opinion the line below (v) should work when uncommented (but it does not)
	#network.connect("connection_failed", onConnectionFailed)
	network.connect("peer_connected", onConnectionSucceeded)

func onConnectionFailed():
	print("connection_failed")
	
func onConnectionSucceeded(_id):
	print("peer_connected")

@rpc("any_peer")
func fetchLabyrinthSize(requester):
	rpc_id(1, "fetchLabyrinthSize", requester)
	pass
	
@rpc
func ReturnLabyrinthSize(dimensions, _requester):
	print(dimensions)
	#instance_from_id(requester_scene)
