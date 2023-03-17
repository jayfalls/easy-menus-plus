extends Node
class_name OptionsConstants

# FILE
const config_file_name: String = "user://options.cfg"
const section_name: String = "Options"

# AUDIO
const sfx_bus_name: String = "SFX"
const music_bus_name: String = "Music" 
const sfx_volume_key_name: String = "sfx_volume"
const music_volume_key_name: String = "music_volume" 
# DISPLAY
const fullscreen_key_name: String = "fullscreen"
const vsync_key: String = "vsync"
const fsr_key: String = "fsr"
const fsr_sharpness_key: String = "fsr_sharpness"
const render_scale_key: String = "render_scale"
const aa_mode_key: String = "aa_mode" 

# DEFAULTS
# AUDIO
const def_sfx_volume: float = 1
const def_music_volume: float = 1
# DISPLAY
const def_fullscreen: bool = false
const def_vsync: bool = true
const def_fsr: bool = false
const def_fsr_sharpness: int = 78
const def_render_scale: float = 1.0
const def_aa_mode: int = 4
