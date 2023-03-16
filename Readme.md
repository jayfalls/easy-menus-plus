# Easy Menus Plus
# !!!WIP!!!
Fork of [EasyMenus](https://github.com/SavoVuksan/EasyMenus).
Adds a basic Main, Options & Pause Menu, with controller support.
Expanded options and features over EasyMenus.

# Features
* Keyboard and Gamepad support
* Various audio and video settings
* Autosaving and loading of settings (Data persistence)

# Main Menu
<img src="Screenshots/main_menu.gif" width="600" />

Just connect your scene loading logic to the `start_game_pressed` signal of the main menu scene.

# Options Menu

The options menu loads and persists the settings when opened/closed. The data is saved in the `user://options.cfg` (e.g. `C:\Users\<Username>\AppData\Roaming\Godot\app_userdata\<Project>/options.cfg` on Windows) file.

The Options Menu offers following settings to be changed
* SFX Volume
* Music Volume
* Fullscreen mode
* VSync
* FSR with adjustable sharpness
* Render Scale for 3D Scenes
* Anti Aliasing (MSAA / TAA)

The menu emits a `close` `signal` when closed. With this architecture the parent node decides what to do when the options menu is closed. 

# How to use
* Add the `res://addons/MenuTemplates/Nodes/menu_templates_manager.tscn` scene to the autoload of your project.
* For the Audio Sliders to work properly you need to create 2 Audio Buses one called `SFX` and the other called `Music` in your audio bus layout file

# Upcoming Features
* Mobile support
* Transitions & Loading screens with presets
* Pause screen overlays/effects with presets
* Previews of settings changes
* Option to change resolution with ultrawide support
* Seperation of audio & display in the options menu

## Completed Additions
* Reworked the options menu to be more mobile friendly
* Added FSR to options menu
* Added TAA to options menu
