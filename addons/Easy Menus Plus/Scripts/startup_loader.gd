extends Node
#Loads options like volume and graphic options on game startup

var config = ConfigFile.new()

# Loads settings from config file. Loads with standard values if settings not 
# existing
func load_settings():
	var err = config.load(OptionsConstants.config_file_name)
	
	if err != OK:
		return
	
	var sfx_bus_index = AudioServer.get_bus_index(OptionsConstants.sfx_bus_name)
	var music_bus_index = AudioServer.get_bus_index(OptionsConstants.music_bus_name)
	var sfx_volume = linear_to_db(config.get_value(OptionsConstants.section_name, OptionsConstants.sfx_volume_key_name, 1))
	var music_volume = linear_to_db(config.get_value(OptionsConstants.section_name, OptionsConstants.music_volume_key_name, 1))
	var fullscreen = config.get_value(OptionsConstants.section_name, OptionsConstants.fullscreen_key_name, false)
	var render_quality = config.get_value(OptionsConstants.section_name, OptionsConstants.render_quality_key, 1.0)
	var vsync = config.get_value(OptionsConstants.section_name, OptionsConstants.vsync_key, true)
	var fsr = config.get_value(OptionsConstants.section_name, OptionsConstants.fsr_key, false)
	var aa_mode = config.get_value(OptionsConstants.section_name, OptionsConstants.aa_mode_key, 0)
	
	AudioServer.set_bus_volume_db(sfx_bus_index, sfx_volume)
	AudioServer.set_bus_volume_db(music_bus_index, music_volume)
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	if fsr:
		get_viewport().scaling_3d_mode = 1
	else:
		get_viewport().scaling_3d_mode = 0
	
	get_viewport().scaling_3d_scale = render_quality
	
	get_viewport().set("msaa_2d", Viewport.MSAA_DISABLED)
	get_viewport().set("msaa_3d", Viewport.MSAA_DISABLED)
	get_viewport().use_taa = false
	match aa_mode:
		0:
			return
		1:
			get_viewport().set("msaa_2d",Viewport.MSAA_2X)
			get_viewport().set("msaa_3d",Viewport.MSAA_2X)
		2:
			get_viewport().set("msaa_2d",Viewport.MSAA_4X)
			get_viewport().set("msaa_3d",Viewport.MSAA_4X)
		3:
			get_viewport().set("msaa_2d",Viewport.MSAA_8X)
			get_viewport().set("msaa_3d",Viewport.MSAA_8X)
		4:
			get_viewport().use_taa = true
	
func _ready():
	load_settings()

func set_msaa(mode, index):
	match index:
		0:
			get_viewport().set(mode, Viewport.MSAA_DISABLED)
		1:
			get_viewport().set(mode, Viewport.MSAA_2X)
		2:
			get_viewport().set(mode, Viewport.MSAA_4X)
		3:
			get_viewport().set(mode, Viewport.MSAA_8X)
