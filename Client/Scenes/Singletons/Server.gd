extends Node

#var network = ENetMultiplayerPeer.new()
var network = WebSocketMultiplayerPeer.new()
var ip = "192.168.0.88"

var port = 5000
var url = "wss://" + ip + ":" + str(port)

var label;

# Called when the node enters the scene tree for the first time.
func _ready():
	label = Label.new()
	add_child(label)
	connectToServer()
	await get_tree().create_timer(1.0).timeout
	
	fetchLabyrinthSize("res://Client.tscn")
	pass # Replace with function body.

func _process(_delta):
	if (network.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED ||
	network.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING):
		network.poll();

func connectToServer():
	var clientCAS = load("res://serverCAS.crt")
	#network.create_client(ip, port)
	network.create_client(url, TLSOptions.client_unsafe(clientCAS))
	
	
	multiplayer.set_multiplayer_peer(network)
	#network.connect_to_url(url)
	
	label.text = "client created"
	print("client created")
	
	#https://docs.godotengine.org/en/stable/classes/class_multiplayerapi.html#class-multiplayerapi
	#  ^
	#  |
	#  |
	#in my professional opinion the line below (v) should work when uncommented (but it does not)
	#network.connect("connection_failed", onConnectionFailed)
	network.connect("peer_connected", onConnectionSucceeded)
	multiplayer.connection_failed.connect(onConnectionFailed)


func onConnectionFailed():
	print("connection_failed")
	label.text = "connection_failed"
	
func onConnectionSucceeded(_id):
	print("peer_connected")
	label.text = "peer_connected"

@rpc("any_peer")
func fetchLabyrinthSize(requester):
	rpc_id(1, "fetchLabyrinthSize", requester)
	pass
	
@rpc
func ReturnLabyrinthSize(dimensions, _requester):
	print(dimensions)
	label.text = str(dimensions)
	#instance_from_id(requester_scene)
