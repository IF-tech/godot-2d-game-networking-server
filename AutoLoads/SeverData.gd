extends Node

var player_data


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_data_file = FileAccess.open("res://Data/PlayerData.json", FileAccess.READ)
	var json_object = JSON.new()
	var player_data_json = json_object.parse_string(player_data_file.get_as_text())
	player_data = player_data_json
	
	print(player_data_json)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

