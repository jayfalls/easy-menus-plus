extends Node
class_name EasyMenuInterface

const InputMapUpdater = preload("res://addons/Easy Menus Plus/Scripts/input_map_updater.gd")

@onready var ControllerEchoInputGenerator = $ControllerEchoInputGenerator
@onready var options_manager: OptionsManager = $OptionsManager

# Default Scenes
@export var main_menu: PackedScene = preload("res://addons/Easy Menus Plus/Main Menu/main_menu.tscn")
@export var options_menu: PackedScene = preload("res://addons/Easy Menus Plus/Options Menu/options_menu.tscn")
@export var pause_menu: PackedScene = preload("res://addons/Easy Menus Plus/Pause Menu/pause_menu.tscn")
# Theme
@export var theme: Theme

var render_view: SubViewport = SubViewport.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	InputMapUpdater.new()._ready()
	var container = SubViewportContainer.new()
	get_tree().root.add_child(container)
	container.add_child(render_view)
