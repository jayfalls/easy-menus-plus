extends Control
class_name EasyMainMenu

signal start_game_pressed

@onready var start_game_button: Button = $%StartGameButton
@onready var options_menu: EasyOptionsMenu
@onready var content: Control = $Content 


func _ready():
	await get_tree().process_frame
	spawn_options()
	start_game_button.grab_focus()

func spawn_options():
	options_menu = MenuInterface.options_menu.instantiate()
	options_menu.visible = false
	add_child(options_menu)
	options_menu.close.connect(close_options)

func quit():
	get_tree().quit()
	
func open_options():
	options_menu.show()
	content.hide()
	options_menu.on_open()
	
func close_options():
	content.show();
	start_game_button.grab_focus()
	options_menu.hide()


func _on_start_game_button_pressed():
	emit_signal("start_game_pressed")


func _on_options_menu_close():
	pass # Replace with function body.
