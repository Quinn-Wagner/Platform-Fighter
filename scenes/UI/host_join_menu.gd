extends Control

@export var address = "127.0.0.1"
@export var port = 8910

var peer
var _players = {}

@onready var _name = $LineEdit
@onready var _list = $PlayerList

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func peer_connected(id):
	print("Player Connected: " + str(id))
	if multiplayer.is_server():
		rpc_id(id, "send_peer_info", _name.text, multiplayer.get_unique_id())
		broadcast_player_list()

func peer_disconnected(id):
	print("Player Disconnected: " + str(id))
	if multiplayer.is_server():
		rpc("del_player", id)
		_players.erase(id)
		broadcast_player_list()

func connected_to_server():
	print("Connected to Server")
	send_peer_info.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

func connection_failed():
	print("Connection Failed")

@rpc("any_peer")
func send_peer_info(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {"name": name, "id": id, "score": 0}
	update_player_name(id, name)
	if multiplayer.is_server():
		broadcast_player_list()
		for i in GameManager.Players:
			send_peer_info.rpc(GameManager.Players[i].name, i)

func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)

	if error != OK:
		print("Cannot Host " + str(error))
		return

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	send_peer_info($LineEdit.text, multiplayer.get_unique_id())
	add_player(multiplayer.get_unique_id(), _name.text)

func _on_join_pressed():
	_disconnect_cleanup()
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
	
	if error != OK:
		print("Cannot Join " + str(error))
		return

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer

func _on_back_pressed():
	if multiplayer.is_server():
		print("Host is disconnecting, closing server.")
		rpc("close_connection")
	else:
		print("Client is disconnecting.")
		rpc("del_player", multiplayer.get_unique_id())
		_close_network()
	_disconnect_cleanup()
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")

func _close_network():
	if multiplayer.get_multiplayer_peer() != null:
		multiplayer.get_multiplayer_peer().disconnect_peer(multiplayer.get_unique_id())
		multiplayer.set_multiplayer_peer(null)

func _disconnect_cleanup():
	_players.clear()
	_list.clear()
	if peer:
		peer.close()

@rpc("any_peer", "call_local")
func close_connection():
	if multiplayer.is_server():
		for player_id in _players.keys():
			rpc_id(player_id, "server_closed")
	if peer:
		peer.close()
	_disconnect_cleanup()

@rpc("any_peer", "call_local")
func server_closed():
	_disconnect_cleanup()

@rpc("any_peer", "call_local")
func add_player(id, _name=""):
	if !_players.has(id):
		_players[id] = _name
		_list.add_item(_name if _name != "" else "... connecting ...", null, false)

@rpc("any_peer", "call_local")
func del_player(id):
	if _players.has(id):
		var pos = _players.keys().find(id)
		_players.erase(id)
		if pos != -1:
			_list.remove_item(pos)

@rpc("any_peer", "call_local")
func update_player_name(player, _name):
	if _players.has(player):
		var pos = _players.keys().find(player)
		if pos != -1:
			_players[player] = _name
			_list.set_item_text(pos, _name)
	else:
		add_player(player, _name)

func broadcast_player_list():
	for player_id in _players.keys():
		rpc("update_player_name", player_id, _players[player_id])

func _on_select_level_pressed():
	if multiplayer.is_server():
		rpc('level_select')
		
@rpc("any_peer", "call_local")
func level_select():
	var scene = load("res://scenes/UI/map_select_menu.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
