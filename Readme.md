# Easy Menus Plus
# !!!WIP!!!
Fork of [EasyMenus](https://github.com/SavoVuksan/EasyMenus).
Adds a basic Main, Options & Pause Menu, with controller support.
Expanded options and features over EasyMenus.

# Features
* Keyboard and Gamepad support
* Various audio and video settings
* Autosaving and loading of settings (Data persistence)

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

## Completed Additions
* Reworked the options menu to be more mobile friendly
* Added FSR to options menu
* Added TAA to options menu
* Added Preliminary Ultrawide support
