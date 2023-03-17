extends Node

#const OptionConstants = preload("res://addons/Easy Menus Plus/Managers/options_constants.gd")
const InputMapUpdater = preload("res://addons/Easy Menus Plus/Scripts/input_map_updater.gd")

@onready var ControllerEchoInputGenerator = $ControllerEchoInputGenerator
@onready var options_manager: OptionsManager = $OptionsManager

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMapUpdater.new()._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
