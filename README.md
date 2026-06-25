# Game template for [godot-mapper](https://github.com/ELF32bit/godot-mapper) plugin
![Demonstration](screenshots/demonstration.png)<br>
The rolling ball type of game is perfect for beginners to experiment with.<br>
Unfortunately, even a simple game like that requires quite many directories.<br>
Set **`Generic`** game path to the project **`mapping`** directory in **TrenchBroom**.<br>

> Project configuration can be changed in **`addons/mapper.gd`** games file.

## Project directories
* **`addons`** is a directory for modular code (plugins, tools).
* **`application`** should contain application files and global settings.
* **`characters`** contains [special maps](https://github.com/ELF32bit/godot-mapper-characters) with animated layers for prototyping.
* **`interfaces`** should contain all kinds of buttons, progress bars, etc...
* **`mapping`** is the main directory for game levels with map resources.
* **`sources`** should contain all game logic and the game state.

## Taking it further
1. Create a moving platform with **`func_train`** classname.
2. Create animation player node inside the start scene.
3. Animate the platform by hand, set as autoplay.
