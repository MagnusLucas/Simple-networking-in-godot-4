extends Node

var data
# Called when the node enters the scene tree for the first time.
func _ready():
	var data_file = FileAccess.open("res://Data/Data.json", FileAccess.READ)
	var json_data = JSON.parse_string(data_file.get_as_text())
	data_file.close()
	data = json_data
	#print(json_data["Labyrinth"]["Size"])
	pass # Replace with function body.

