extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"

var port = 5000


# Called when the node enters the scene tree for the first time.
func _ready():
	connectToServer()
	await get_tree().create_timer(1.0).timeout
	fetchLabyrinthSize("res://Client.tscn")
	pass # Replace with function body.

func connectToServer():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
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
