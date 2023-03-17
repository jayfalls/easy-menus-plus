extends Node

const InputMapUpdater = preload("res://addons/Easy Menus Plus/Scripts/input_map_updater.gd")

@onready var ControllerEchoInputGenerator = $ControllerEchoInputGenerator
@onready var options_manager: OptionsManager = $OptionsManager

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMapUpdater.new()._ready()
