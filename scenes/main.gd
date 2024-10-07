extends Control

var curr_level_instance
var curr_level_name
var cheese_amount = 0
@onready var main_menu = $Menus/CanvasLayer/Main
@onready var how_to_play_menu = $Menus/CanvasLayer/HowToPlay
@onready var level_select_menu = $Menus/CanvasLayer/LevelSelect
@onready var options_menu = $Menus/CanvasLayer/Options
@onready var game_over_menu = $Menus/CanvasLayer/GameOver
@onready var color_rect = $Menus/CanvasLayer/ColorRect
@onready var canvas_modulate = $CanvasModulate
@onready var UI_camera = $"UI Cam"
@onready var HUD = $Menus/CanvasLayer/HUD
@onready var cheese_hud = $Menus/CanvasLayer/HUD/VBoxContainer/GridContainer2/CheeseIcon
@onready var health_hud = $Menus/CanvasLayer/HUD/VBoxContainer/GridContainer/HealthIcon
@onready var game_over_text = $Menus/CanvasLayer/GameOver/VBoxContainer/Label
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

func unload_level():
	if (is_instance_valid(curr_level_instance)):
		curr_level_instance.queue_free()
	curr_level_instance = null
	UI_camera.enabled = true

func load_level(level_name: String):
	unload_level()
	var level_path := "res://levels/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (level_resource):
		curr_level_name = level_name
		curr_level_instance = level_resource.instantiate()
		add_child(curr_level_instance)
	close_all_menus()
	HUD.show()
	
	UI_camera.enabled = false
	var player = get_tree().get_first_node_in_group("player")
	var cheeses = get_tree().get_nodes_in_group("cheese")
	for cheese in cheeses:
		cheese.cheese_grabbed.connect(cheese_was_grabbed)
		cheese.cheese_grabbed.connect(cheese_hud.update_cheese_hud)
	player.health_changed.connect(health_hud.update_health_hud)
	player.died.connect(player_died)
	player.won.connect(player_won)
	cheese_amount = 0
	cheese_hud.update_cheese_hud(0)
	cheese_hud.visible = false

func cheese_was_grabbed():
	cheese_amount += 1
	cheese_hud.update_cheese_hud(cheese_amount)

func player_won():
	unload_level()
	open_menu("GameOver")
	game_over_text.text = "NICE JOB!"
		
func player_died():
	unload_level()
	open_menu("GameOver")
	game_over_text.text = "Try again?"
	
func close_all_menus():
	main_menu.hide()
	how_to_play_menu.hide()
	level_select_menu.hide()
	options_menu.hide()
	game_over_menu.hide()
	color_rect.hide()
	HUD.hide()
	canvas_modulate.show()
	
func open_menu(menu: String):
	close_all_menus()
	color_rect.show()
	canvas_modulate.hide()
	get_node("Menus/CanvasLayer/"+menu).show()

func _on_howto_play_button_pressed() -> void:
	open_menu("HowToPlay")


func _on_return_from_how_to_play_pressed() -> void:
	open_menu("Main")


func _on_return_from_level_select_pressed() -> void:
	open_menu("Main")


func _on_level_select_button_pressed() -> void:
	open_menu("LevelSelect")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_load_level_1_pressed() -> void:
	load_level("Level1")

func _on_load_level_2_pressed() -> void:
	load_level("Level2")

func _on_load_level_3_pressed() -> void:
	load_level("Level3")

func _on_load_level_4_pressed() -> void:
	load_level("Level4")

func _on_load_level_5_pressed() -> void:
	load_level("Level5")


func _on_options_button_pressed() -> void:
	open_menu("Options")


func _on_return_from_options_pressed() -> void:
	open_menu("Main")


func _on_fullscreen_toggle_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_restart_level_pressed() -> void:
	load_level(curr_level_name)


func _on_return_from_game_over_pressed() -> void:
	open_menu("LevelSelect")


func _on_music_slider_value_changed(value: float) -> void:
	print("here")
	print(value)
	print(linear_to_db(value))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.05)
	print(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	
	


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.05)
