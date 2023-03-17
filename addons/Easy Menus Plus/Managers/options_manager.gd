extends Node
class_name OptionsManager

# VARIABLES
var config: ConfigFile = ConfigFile.new()
# Config Values
var sfx_volume: float
var music_volume: float
var fullscreen: bool
var vsync: bool
var fsr: bool
var render_scale: float
var fsr_sharpness: int
var aa_mode: int
## Audio
var sfx_bus_index: int
var music_bus_index: int
enum audio_busses {
	MUSIC,
	SFX
}
## Rendering Quality Values
const render_qualities: Dictionary = {
	native = 1.0,
	ultra_quality = 0.77,
	quality = 0.67,
	balanced = 0.59,
	performance = 0.5,
	fsr_native = 0.9
}
## Anti-Aliasing Values
enum aa_modes {
	OFF,
	TX,
	FX,
	EX,
	TAA
}


# INITIALISATION
func _ready():
	sfx_bus_index = AudioServer.get_bus_index(OptionsConstants.sfx_bus_name)
	music_bus_index = AudioServer.get_bus_index(OptionsConstants.music_bus_name)
	load_settings()


# INPUT/OUTPUT
## Loads settings from config file. Loads with standard values if settings not existing
func load_settings():
	# Stops if there is an error loading the file
	var err = config.load(OptionsConstants.config_file_name)
	if err != OK:
		return
	
	var section_name: String = OptionsConstants.section_name
	# Audio
	set_volume(music_bus_index, config.get_value(section_name, OptionsConstants.music_volume_key_name, OptionsConstants.def_music_volume))
	set_volume(sfx_bus_index, config.get_value(section_name, OptionsConstants.sfx_volume_key_name, OptionsConstants.def_sfx_volume))
	# Display
	set_fullscreen(config.get_value(section_name, OptionsConstants.fullscreen_key_name, OptionsConstants.def_fullscreen))
	set_vsync(config.get_value(section_name, OptionsConstants.vsync_key, OptionsConstants.def_vsync))
	set_fsr(config.get_value(section_name, OptionsConstants.fsr_key, OptionsConstants.def_fsr))
	int_to_fsr_sharpness(config.get_value(section_name, OptionsConstants.fsr_sharpness_key, OptionsConstants.def_fsr_sharpness))
	set_render_scale(config.get_value(section_name, OptionsConstants.render_scale_key, OptionsConstants.def_render_scale))
	set_aa_mode(config.get_value(section_name, OptionsConstants.aa_mode_key, OptionsConstants.def_aa_mode))

# Saves values to config file
func save_options():
	var section_name: String = OptionsConstants.section_name
	config.set_value(section_name,OptionsConstants.sfx_volume_key_name, sfx_volume)
	config.set_value(section_name, OptionsConstants.music_volume_key_name, music_volume)
	config.set_value(section_name, OptionsConstants.fullscreen_key_name, fullscreen)
	config.set_value(section_name, OptionsConstants.vsync_key, vsync)
	config.set_value(section_name, OptionsConstants.fsr_key, fsr)
	config.set_value(section_name, OptionsConstants.render_scale_key, render_scale);
	config.set_value(section_name, OptionsConstants.fsr_sharpness_key, fsr_sharpness)
	config.set_value(section_name, OptionsConstants.aa_mode_key, aa_mode)
	
	config.save(OptionsConstants.config_file_name)

func reset_defaults():
	set_volume(music_bus_index, OptionsConstants.def_music_volume)
	set_volume(sfx_bus_index, OptionsConstants.def_sfx_volume)
	# Display
	set_fullscreen(OptionsConstants.def_fullscreen)
	set_vsync(OptionsConstants.def_vsync)
	set_fsr(OptionsConstants.def_fsr)
	int_to_fsr_sharpness(OptionsConstants.def_fsr_sharpness)
	set_render_scale(OptionsConstants.def_render_scale)
	set_aa_mode(OptionsConstants.def_aa_mode)


# UPDATE SETTINGS
# AUDIO
func set_volume(bus_index: int, value: float):
	match bus_index:
		music_bus_index:
			music_volume = value
		sfx_bus_index:
			sfx_volume = value
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


# DISPLAY
func set_fullscreen(state: bool):
	fullscreen = state
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_vsync(state: bool):
	# There are multiple V-Sync Methods supported by Godot 
	# For now we just use the simple ones could be worth a consideration to  add the others
	# Just sets V-Sync for the first window. So no support for multi window games
	vsync = state
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func set_fsr(state: bool):
	fsr = state
	if fsr:
		get_viewport().scaling_3d_mode = 1
	else:
		get_viewport().scaling_3d_mode = 0

## FSR Sharpness
### In this instance, I am storing the value in a range between 0-100, and am saving that value
func int_to_fsr_sharpness(value: int):
	fsr_sharpness = value
	# Accepts values from 0-100
	value = remap(value, 0, 100 , 0, 1)
	# Logarithm ensures a smoother transition between sharpness levels
	# With this logarithm, a value of 0.78 equates to 0.2, Godot's recommended balanced sharpness
	value = log(value) / log(0.3)
	value = snapped(clamp(value, 0, 2), 0.001)
	set_fsr_sharpness(value)

func set_fsr_sharpness(value: float):
	get_viewport().fsr_sharpness = value

## Resolution Scaling
func set_render_scale(value: float):
	render_scale = value
	get_viewport().scaling_3d_scale = render_scale

## Anti-Aliasing
func set_aa_mode(index: int):
	aa_mode = index
	# Disable AA
	get_viewport().set("msaa_2d", Viewport.MSAA_DISABLED)
	get_viewport().set("msaa_3d", Viewport.MSAA_DISABLED)
	get_viewport().use_taa = false
	
	# Set new AA
	match aa_mode:
		aa_modes.OFF:
			return
		aa_modes.TX:
			get_viewport().set("msaa_2d",Viewport.MSAA_2X)
			get_viewport().set("msaa_3d",Viewport.MSAA_2X)
		aa_modes.FX:
			get_viewport().set("msaa_2d",Viewport.MSAA_4X)
			get_viewport().set("msaa_3d",Viewport.MSAA_4X)
		aa_modes.EX:
			get_viewport().set("msaa_2d",Viewport.MSAA_8X)
			get_viewport().set("msaa_3d",Viewport.MSAA_8X)
		aa_modes.TAA:
			get_viewport().use_taa = true
