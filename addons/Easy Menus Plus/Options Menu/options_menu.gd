extends Control
class_name EasyOptionsMenu

# SIGNALS
signal  close


# VARIABLES
## Preload
@onready var manager: OptionsManager = MenuInterface.options_manager
### UI
@onready var ultrawide_margin: UltrawideMarginContainer = $MarginContainer/ScrollContainer/UltrawideMarginContainer
@onready var sfx_volume_slider : HSliderWLabel = $%SFXVolumeSlider
@onready var music_volume_slider: HSliderWLabel = $%MusicVolumeSlider
@onready var aspect_ratios_button: OptionButton = $%AspectRatiosButton
@onready var resolutions_button: OptionButton = $%ResolutionButton
@onready var fullscreen_check_button: CheckButton = $%FullscreenCheckButton
@onready var vsync_check_button: CheckButton = $%VSyncCheckButton
@onready var fsr_check_button: CheckButton = $%FSRCheckButton
@onready var fsr_sharpness_slider: HSlider = $%FSRSharpnessSlider.hslider


# LOADING & UNLOADING
## Called from outside initializes the options menu
func on_open():
	sfx_volume_slider.hslider.grab_focus()
	load_options()

## Emits close signal and saves the options
func go_back():
	manager.save_options()
	emit_signal("close")

func _input(event):
	if event.is_action_pressed("ui_cancel") && visible:
		accept_event()
		go_back()

## Loads options and sets the controls values to loaded values. Uses default values if config file does not exist
func load_options():
	manager.load_settings()
	assign_options()

# Resets all the options to default
func _on_reset_defaults_button_pressed():
	manager.reset_defaults()
	assign_options()

## Updates the UI with the values stored in the manager
func assign_options():
	# Audio
	sfx_volume_slider.hslider.value = manager.sfx_volume
	music_volume_slider.hslider.value = manager.music_volume
	#Display
	fullscreen_check_button.button_pressed = manager.fullscreen
	# Need to set it like that to guarantee signal to be triggered
	vsync_check_button.set_pressed_no_signal(manager.vsync)
	vsync_check_button.emit_signal("toggled", manager.vsync)
	fsr_check_button.set_pressed_no_signal(manager.fsr)
	fsr_check_button.emit_signal("toggled", manager.fsr)
	
	# Assign the right render quality button
	var render_quality_buttons: Array[BaseButton] = $%NativeButton.button_group.get_buttons()
	var current_quality: String = OptionsConstants.render_scales.find_key(manager.render_scale)
	var quality_index: int = OptionsConstants.render_scales.keys().find(current_quality)
	## Accounting for two different native scales, with only one button
	if quality_index == OptionsConstants.render_scales.size() - 1:
		render_quality_buttons[0].button_pressed = true
	else:
		render_quality_buttons[quality_index].button_pressed = true
	
	# Assign FSR sharpness
	fsr_sharpness_slider.value = manager.fsr_sharpness
	# Assign the right AA button
	var aa_buttons: Array[BaseButton] = $%TAAButton.button_group.get_buttons()
	aa_buttons[manager.aa_mode].button_pressed = true


# UI CHANGES
# AUDIO
func _on_sfx_volume_slider_value_changed(value):
	manager.set_volume(manager.sfx_bus_index, value)

func _on_music_volume_slider_value_changed(value):
	manager.set_volume(manager.music_bus_index, value)

# DISPLAY OPTIONS
## Resolution
func _on_aspect_ratio_button_item_selected(index):
	resolutions_button.clear()
	var resolutions: Array[Vector2i] = OptionsConstants[OptionsConstants.aspects_to_res_map[index]]
	for res in resolutions:
		var text: String = str(res.x) + "x" + str(res.y)
		resolutions_button.add_item(text)

func _on_resolution_apply_button_pressed():
	var res_text: String = resolutions_button.get_item_text(resolutions_button.get_selected_id())
	var split_index: int = res_text.find("x")
	var x: int = int(res_text.substr(0, split_index))
	var y: int = int(res_text.substr(split_index + 1, res_text.length() - split_index))
	manager.resolution = Vector2i(x,y)

## Display Settings
func _on_fullscreen_check_button_toggled(button_pressed):
	manager.set_fullscreen(button_pressed)

func _on_v_sync_check_button_toggled(button_pressed):
	manager.set_vsync(button_pressed)

## FSR
func _on_fsr_check_button_toggled(button_pressed):
	manager.set_fsr(button_pressed)
	toggle_fsr_options(button_pressed)

func toggle_fsr_options(state: bool):
	fsr_sharpness_slider.editable = state
	# Stop execution if native rendering quality isn't selected
	if manager.render_scale < OptionsConstants.render_scales["fsr_native"]:
		return
	# Assigns render quality based on FSR state
	if state == true:
		manager.set_render_scale(OptionsConstants.render_scales["fsr_native"])
	else:
		manager.set_render_scale(OptionsConstants.render_scales["native"])

## Sharpness
func _on_fsr_sharpness_slider_value_changed(value):
	manager.int_to_fsr_sharpness(value)

## Resolution Scaling
func _on_native_button_pressed():
	if fsr_check_button.toggled:
		manager.set_render_scale(OptionsConstants.render_scales["fsr_native"])
	else:
		manager.set_render_scale(OptionsConstants.render_scales["native"])
func _on_ultra_quality_button_pressed():
	manager.set_render_scale(OptionsConstants.render_scales["ultra_quality"])
func _on_quality_button_pressed():
	manager.set_render_scale(OptionsConstants.render_scales["quality"])
func _on_balanced_button_pressed():
	manager.set_render_scale(OptionsConstants.render_scales["balanced"])
func _on_performance_button_pressed():
	manager.set_render_scale(OptionsConstants.render_scales["performance"])

## AA Options
func _on_off_button_pressed():
	manager.set_aa_mode(OptionsConstants.aa_modes.OFF)
func _on_2x_button_pressed():
	manager.set_aa_mode(OptionsConstants.aa_modes.TX)
func _on_4x_button_pressed():
	manager.set_aa_mode(OptionsConstants.aa_modes.FX)
func _on_8x_button_pressed():
	manager.set_aa_mode(OptionsConstants.aa_modes.EX)
func _on_taa_button_pressed():
	manager.set_aa_mode(OptionsConstants.aa_modes.TAA)
