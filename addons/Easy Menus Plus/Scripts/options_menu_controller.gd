extends Control
signal  close

@onready var sfx_volume_slider : HSliderWLabel = $%SFXVolumeSlider
@onready var music_volume_slider: HSliderWLabel = $%MusicVolumeSlider
@onready var fullscreen_check_button: CheckButton = $%FullscreenCheckButton
@onready var vsync_check_button: CheckButton = $%VSyncCheckButton
@onready var fsr_check_button: CheckButton = $%FSRCheckButton
@onready var fsr_sharpness_slider: HSlider = $%FSRSharpnessSlider.hslider

var sfx_bus_index
var music_bus_index

# Rendering Quality Values
const render_qualities: Dictionary = {
	native = 1.0,
	ultra_quality = 0.77,
	quality = 0.67,
	balanced = 0.59,
	performance = 0.5,
	fsr_native = 0.9
}
var render_quality: float :
	set (value):
		render_quality = value
		get_viewport().scaling_3d_scale = value

# Anti-Aliasing Values
enum aa_modes {
	OFF,
	TX,
	FX,
	EX,
	TAA
} 
var aa_mode: int :
	set (value):
		aa_mode = value
		get_viewport().set("msaa_2d", Viewport.MSAA_DISABLED)
		get_viewport().set("msaa_3d", Viewport.MSAA_DISABLED)
		get_viewport().use_taa = false
		
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

var config = ConfigFile.new()


# LOADING & UNLOADING
## Saves the options when the options menu is closed
func save_options():
	config.set_value(OptionsConstants.section_name,OptionsConstants.sfx_volume_key_name, sfx_volume_slider.hslider.value)
	config.set_value(OptionsConstants.section_name, OptionsConstants.music_volume_key_name, music_volume_slider.hslider.value)
	config.set_value(OptionsConstants.section_name, OptionsConstants.fullscreen_key_name, fullscreen_check_button.button_pressed)
	config.set_value(OptionsConstants.section_name, OptionsConstants.vsync_key, vsync_check_button.button_pressed)
	config.set_value(OptionsConstants.section_name, OptionsConstants.fsr_key, fsr_check_button.button_pressed)
	config.set_value(OptionsConstants.section_name, OptionsConstants.render_quality_key, render_quality);
	config.set_value(OptionsConstants.section_name, OptionsConstants.fsr_sharpness_key, fsr_sharpness_slider.value)
	config.set_value(OptionsConstants.section_name, OptionsConstants.aa_mode_key, aa_mode)
	
	config.save(OptionsConstants.config_file_name)

## Loads options and sets the controls values to loaded values. Uses default values if config file does not exist
func load_options():
	var err = config.load(OptionsConstants.config_file_name)
	
	var sfx_volume = config.get_value(OptionsConstants.section_name, OptionsConstants.sfx_volume_key_name, 1)
	var music_volume = config.get_value(OptionsConstants.section_name, OptionsConstants.music_volume_key_name, 1)
	var fullscreen = config.get_value(OptionsConstants.section_name, OptionsConstants.fullscreen_key_name, false)
	var vsync = config.get_value(OptionsConstants.section_name, OptionsConstants.vsync_key, true)
	var fsr = config.get_value(OptionsConstants.section_name, OptionsConstants.fsr_key, false)
	self.render_quality = config.get_value(OptionsConstants.section_name, OptionsConstants.render_quality_key, render_qualities["native"])
	var fsr_sharpness = config.get_value(OptionsConstants.section_name, OptionsConstants.fsr_sharpness_key, 78)
	self.aa_mode = config.get_value(OptionsConstants.section_name, OptionsConstants.aa_mode_key, 0)
	
	sfx_volume_slider.hslider.value = sfx_volume
	music_volume_slider.hslider.value = music_volume
	fullscreen_check_button.button_pressed = fullscreen
	
	# Assign the right render quality button
	var render_quality_buttons: Array[BaseButton] = $%NativeButton.button_group.get_buttons()
	var current_quality: String = render_qualities.find_key(render_quality)
	var quality_index: int = render_qualities.keys().find(current_quality)
	## Accounting for two different native scales, with only one button
	if quality_index == render_qualities.size() - 1:
		render_quality_buttons[0].button_pressed = true
	else:
		render_quality_buttons[quality_index].button_pressed = true
	
	# Need to set it like that to guarantee signal to be triggered
	fsr_check_button.set_pressed_no_signal(fsr)
	fsr_check_button.emit_signal("toggled", fsr)
	vsync_check_button.set_pressed_no_signal(vsync)
	vsync_check_button.emit_signal("toggled", vsync)
	
	# Assign FSR sharpness
	fsr_sharpness_slider.value = fsr_sharpness
	
	# Assign the right AA button
	var aa_buttons: Array[BaseButton] = $%TAAButton.button_group.get_buttons()
	aa_buttons[aa_mode].button_pressed = true


## Emits close signal and saves the options
func go_back():
	save_options()
	emit_signal("close")

## Called from outside initializes the options menu
func on_open():
	sfx_volume_slider.hslider.grab_focus()
	
	sfx_bus_index = AudioServer.get_bus_index(OptionsConstants.sfx_bus_name)
	music_bus_index = AudioServer.get_bus_index(OptionsConstants.music_bus_name)
	
	load_options()


# AUDIO
func _on_sfx_volume_slider_value_changed(value):
	set_volume(sfx_bus_index, value)

func _on_music_volume_slider_value_changed(value):
	set_volume(music_bus_index, value)

## Sets the volume for the given audio bus
func set_volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


## DISPLAY OPTIONS
func _on_fullscreen_check_button_toggled(button_pressed):
	if button_pressed:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_v_sync_check_button_toggled(button_pressed):
	# There are multiple V-Sync Methods supported by Godot 
	# For now we just use the simple ones could be worth a consideration to 
	# add the others
	# Just sets V-Sync for the first window. So no support for multi window games
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _input(event):
	if event.is_action_pressed("ui_cancel") && visible:
		accept_event()
		go_back()


# FSR
## Toggle
func _on_fsr_check_button_toggled(button_pressed):
	if button_pressed:
		get_viewport().scaling_3d_mode = 1
		toggle_fsr_options(true)
	else:
		get_viewport().scaling_3d_mode = 0
		toggle_fsr_options(false)

func toggle_fsr_options(state: bool):
	fsr_sharpness_slider.editable = state
	
	# Stop execution if native rendering quality isn't selected
	if render_quality < render_qualities["fsr_native"]:
		return
	
	if state == true:
		self.render_quality = render_qualities["fsr_native"]
	else:
		self.render_quality = render_qualities["native"]

## Sharpness
func _on_fsr_sharpness_slider_value_changed(value):
	value = remap(value, 0, 100 , 0, 1)
	# Logarithm ensures a smoother transition between sharpness levels
	# With this logarithm, a value of 0.78 equates to 0.2, Godot's recommended balanced sharpness
	value = log(value) / log(0.3)
	value = snapped(clamp(value, 0, 2), 0.001)
	get_viewport().fsr_sharpness = value


## RESOLUTION SCALING
func _on_native_button_pressed():
	if fsr_check_button.toggled:
		self.render_quality = render_qualities["fsr_native"]
	else:
		self.render_quality = render_qualities["native"]

func _on_ultra_quality_button_pressed():
	self.render_quality = render_qualities["ultra_quality"]

func _on_quality_button_pressed():
	self.render_quality = render_qualities["quality"]

func _on_balanced_button_pressed():
	self.render_quality = render_qualities["balanced"]

func _on_performance_button_pressed():
	self.render_quality = render_qualities["performance"]


# AA OPTIONS
func _on_off_button_pressed():
	self.aa_mode = aa_modes.OFF

func _on_2x_button_pressed():
	self.aa_mode = aa_modes.TX

func _on_4x_button_pressed():
	self.aa_mode = aa_modes.FX

func _on_8x_button_pressed():
	self.aa_mode = aa_modes.EX

func _on_taa_button_pressed():
	self.aa_mode = aa_modes.TAA
