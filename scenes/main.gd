extends Control

var curr_level_instance
@onready var main_menu = $Menus/Main
@onready var how_to_play_menu = $Menus/HowToPlay
@onready var level_select_menu = $Menus/LevelSelect
@onready var options_menu = $Menus/Options
@onready var color_rect = $Menus/ColorRect
@onready var canvas_modulate = $CanvasModulate
@onready var UI_camera = $"UI Cam"

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
		curr_level_instance = level_resource.instantiate()
		add_child(curr_level_instance)
	close_all_menus()
	UI_camera.enabled = false

func close_all_menus():
	main_menu.hide()
	how_to_play_menu.hide()
	level_select_menu.hide()
	options_menu.hide()
	color_rect.hide()
	canvas_modulate.show()
	
func open_menu(menu: String):
	close_all_menus()
	color_rect.show()
	canvas_modulate.hide()
	get_node("Menus/"+menu).show()

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
