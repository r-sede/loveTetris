# TETRIS Love2D Remake

A classic Tetris remake inspired by the original Game Boy version (1989), built with [Love2D](https://love2d.org/) in pure spaghetti code style.

Source: [Tetris Dossier](https://www.colinfahey.com/tetris/tetris.html)

![Tetris Remake Screenshot](https://github.com/r-sede/loveTetris/raw/master/assets/img/tetrisScreen.jpg ':v')

---

## Features

- Authentic Game Boy-style Tetris gameplay
- States (e.g., Game Over, etc.)
- Title screen with menu (Play, High Scores)
- Platform-specific builds for Windows, macOS, and Linux

---

## TODO

- [ ] Add high score file
- [x] Add game states (e.g., Game Over)
- [x] Add menu on title screen (Play / High Scores)
- [x] Build Windows (32-bit and 64-bit) executables
- [x] Build macOS `.app`
- [x] Build Linux `.AppImage`
- [x] Build a Love2D `.love` file

---

## Controls

- **Arrow keys:** Move piece (hold or spam)
- **Esc:** Quit game
- **D:** Toggle debug info
- **G:** Toggle grid visibility
- **M:** Mute sound
- **Space:** Pause game
- **X:** Rotate piece clockwise
- **S:** Rotate piece counterclockwise

---

## Installation

### Windows:

1. Download the `tetris_win32.zip` or `tetris_win64.zip` release from the [releases page](https://github.com/r-sede/loveTetris/releases).
2. Extract the ZIP file and run `tetris.exe`.

### Linux:

1. Install the `love2d` package for your distribution.

   For **Debian-based distributions** (e.g., Ubuntu), you can install it via:

   ```bash
   sudo add-apt-repository ppa:bartbes/love-stable
   sudo apt-get update
   sudo apt-get install love

2. Clone the repository and run it with Love2D:

    git clone https://github.com/r-sede/loveTetris.git
    cd loveTetris
    love .

### macOS:

1. Download the tetris_macos.zip release from the releases page.
2. Extract the ZIP file and double-click the .app to open.
- If macOS blocks the app, go to System Preferences > Security & Privacy, then click "Open Anyway" next to the Tetris app.

## Credits

* Tetris was originally designed and programmed by Alexey Pajitnov.
* Built with Love2D, a fantastic framework for 2D game development.
