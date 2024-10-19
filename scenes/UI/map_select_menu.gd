extends Control

var map1_selected = false
var map2_selected = false
var map3_selected = false

var current_background = -90
var stashed_background = -100

@onready var map1_background = $Backgrounds/Map1Background
@onready var map2_background = $Backgrounds/Map2Background
@onready var map3_background = $Backgrounds/Map3Background

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/host_join_menu.tscn")

func _on_map_1_toggled(toggled_on):
	map1_selected = true
	map2_selected = false
	map3_selected = false
	
	$HBoxContainer/Map2.button_pressed = false
	$HBoxContainer/Map3.button_pressed = false
	
	map1_background.layer = current_background
	map2_background.layer = stashed_background
	map3_background.layer = stashed_background

func _on_map_2_toggled(toggled_on):
	map2_selected = true
	map1_selected = false
	map3_selected = false
	
	$HBoxContainer/Map1.button_pressed = false
	$HBoxContainer/Map3.button_pressed = false
	
	map2_background.layer = current_background
	map1_background.layer = stashed_background
	map3_background.layer = stashed_background

func _on_map_3_toggled(toggled_on):
	map3_selected = true
	map1_selected = false
	map2_selected = false
	
	$HBoxContainer/Map1.button_pressed = false
	$HBoxContainer/Map2.button_pressed = false
	
	map3_background.layer = current_background
	map1_background.layer = stashed_background
	map2_background.layer = stashed_background

@rpc("any_peer", "call_local")
func start_game():
	if map1_selected:
		var scene = load("res://scenes/environment/Map1.tscn").instantiate()
		get_tree().root.add_child(scene)
		self.hide()
	if map2_selected:
		var scene = load("res://scenes/environment/Map2.tscn").instantiate()
		get_tree().root.add_child(scene)
		self.hide()
	if map3_selected:
		var scene = load("res://scenes/environment/Map2.tscn").instantiate()
		get_tree().root.add_child(scene)
		self.hide()

func _on_start_game_pressed():
	start_game.rpc()
