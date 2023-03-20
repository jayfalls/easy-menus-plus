extends Node
class_name StartupLoader


func _ready():
	await get_tree().process_frame
	var main_menu: EasyMainMenu = MenuInterface.main_menu.instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()
