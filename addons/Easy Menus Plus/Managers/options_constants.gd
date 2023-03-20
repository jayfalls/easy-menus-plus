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
const resolution_key_name: String = "resolution"
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
const def_resolution: Vector2i = Vector2i(800,600)
const def_fullscreen: bool = false
const def_vsync: bool = true
const def_fsr: bool = false
const def_fsr_sharpness: int = 78
const def_render_scale: float = 1.0
const def_aa_mode: int = 4

# OPTIONS
# AUDIO
enum audio_busses {
	MUSIC,
	SFX
}
## Display Resoltions
const aspect_ratios: Array[String] = [
	"3:2",
	"4:3",
	"5:4",
	"16:9",
	"16:10",
	"Ultrawide",
	"Super Ultrawide"
]
const aspects_to_res_map: Array[String] = [
	"three_by_two",
	"four_by_three",
	"five_by_four",
	"sixteen_by_nine",
	"sixteen_by_ten",
	"ultrawide",
	"superwide"
]
const three_by_two: Array[Vector2i] = [
	Vector2i(720,480),
	Vector2i(1152,768),
	Vector2i(1280,854),
	Vector2i(1440,960),
	Vector2i(1920,1280),
	Vector2i(2160,1440),
	Vector2i(2880,1920),
	Vector2i(3000,2000),
	Vector2i(3240,2160),
	Vector2i(4500,3000)
]
const four_by_three: Array[Vector2i] = [
	Vector2i(800,600),
	Vector2i(1024,768),
	Vector2i(1152,864),
	Vector2i(1280,960),
	Vector2i(1400,1050),
	Vector2i(1600,1200),
	Vector2i(2048,1536),
	Vector2i(3840,2880),
	Vector2i(4096,3072)
]
const five_by_four: Array[Vector2i] = [
	Vector2i(1280,1024),
	Vector2i(1600,1280),
	Vector2i(1800,1440),
	Vector2i(2560,2048),
	Vector2i(5120,4096)
]
const sixteen_by_nine: Array[Vector2i] = [
	Vector2i(854,480),
	Vector2i(960,540),
	Vector2i(1024,576),
	Vector2i(1280,720),
	Vector2i(1366,768),
	Vector2i(1600,900),
	Vector2i(1920,1080),
	Vector2i(2560,1440),
	Vector2i(3200,1800),
	Vector2i(3840,2160)
]
const sixteen_by_ten: Array[Vector2i] = [
	Vector2i(960,600),
	Vector2i(1280,800),
	Vector2i(1440,900),
	Vector2i(1680,1050),
	Vector2i(1920,1200),
	Vector2i(2560,1600),
	Vector2i(3840,2400)
]
const ultrawide: Array[Vector2i] = [
	Vector2i(2560,1080),
	Vector2i(2880,1200),
	Vector2i(3440,1440),
	Vector2i(3840,1600),
	Vector2i(4320,1800),
	Vector2i(5120,2160)
]
const superwide: Array[Vector2i] = [
	Vector2i(2880,900),
	Vector2i(3840,1080),
	Vector2i(3840,1200),
	Vector2i(4320,1200),
	Vector2i(5120,1440),
	Vector2i(5120,1600),
	Vector2i(5760,1600),
	Vector2i(5760,1800),
	Vector2i(6400,1800),
	Vector2i(6480,1800),
	Vector2i(7680,2160)
]
## Rendering Quality Values
const render_scales: Dictionary = {
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
