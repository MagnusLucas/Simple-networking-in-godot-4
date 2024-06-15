extends Node

#var network := ENetMultiplayerPeer.new()
var network := WebSocketMultiplayerPeer.new()

const PORT        = 5000
#const MAX_PLAYERS = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	startServer()

func _process(_delta):
	network.poll()

func startServer():
	#network.create_server(PORT, MAX_PLAYERS)
	var serverCert = load("res://serverCAS.crt")
	var serverKey = load("res://serverKey.key")
	
	network.create_server(PORT, "127.0.0.1", TLSOptions.server(serverKey, serverCert))
	multiplayer.set_multiplayer_peer(network)
	print("Server started")
	
	network.connect("peer_connected",    _client_connected   ) 
	network.connect("peer_disconnected",    _client_disconnected   )


	
func _client_connected(player_id):
	print("Client connected! yay; " + str(player_id))


func _client_disconnected(player_id):
	print("Client disconnected. Booooo; " + str(player_id))
	
func crypto_shenanigans():
	var crypto = Crypto.new()
	var key = CryptoKey.new()
	var cert = X509Certificate.new()
	key = crypto.generate_rsa(4096)
	cert = crypto.generate_self_signed_certificate(key, "CN=doofenshmirtz.inc, O=Doofenshmirtz.Evil.Incorporated, C=IT")
	
	key.save("res://serverKey.key")
	cert.save("res://serverCAS.crt")
	

@rpc("any_peer")
func fetchLabyrinthSize(requester):
	print("got a request!")
	var player_id = multiplayer.get_remote_sender_id()
	var size = GameData.data["Labyrinth"]["Size"]
	rpc_id(player_id, "ReturnLabyrinthSize", size, requester)
	print("Sending " + str(size) + " to " + requester + " id: " + str(player_id)) 
	
@rpc
func ReturnLabyrinthSize():
	#implemented only in client
	#it is crucial that it is declared here also, otherwise no @rpc functions will work...
	pass
