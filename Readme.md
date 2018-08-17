# TETRIS love2d remake

A tetris remake based on the GB version (1989)
made with [love2d](https://love2d.org/) <small>_(with love)_</small> in pure spaghetti style

source: [Tetris dossier](https://www.colinfahey.com/tetris/tetris.html)

![Tetris remake screenshot](https://github.com/r-sede/loveTetris/raw/master/assets/img/tetrisScreen.jpg ':v')

### TODO:

- [ ] add high score file
- [x] add states (gameOver etc...)
- [x] add menu to title screen (play/scores)
- [x] Build a win32 .exe


---

## control:

**arrow key:** move piece ( spam the key )

**esc:** quit game

**d:** toggle debug info

**g:** toggle grid

**m:** mute

**space:** pause

**x:** rotate piece clockWise

**s:** rotate piece antiClockWise


---

## windows:

unzip build/loveTetris.zip

run loveTetris.exe

## linux:

install love2d package for your distrib

_ex deb package:_

```
$ sudo add-apt-repository ppa:bartbes/love-stable
$ sudo apt-get update
```

```
$ git clone https://github.com/r-sede/loveTetris.git
$ cd loveTetris
$ love .
```
