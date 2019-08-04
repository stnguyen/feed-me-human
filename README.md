# Feed Me, Human!

![Happy Cat](/Assets/cat.png)

A simple tap-to-blast game, written as a practice to learn [Haxe](haxe.org) and [OpenFL](openfl.org).

Its rules are copied from the (chinese?) puzzle game "PopStar!" (couldn't figure out which link is the original one).

All assets belong to [me](stnguyen.com).

## Demo

[Play HTML5 version](stnguyen.com/feedmehuman/)

## Features

- [x] Random new game board of size 10x10, with uniform distribution for 5 colors
- [x] Tap to blast adjacient cells of the same color. After blasting:
    - Remaining cells fall down to cover the holes.
    - No new cell is added to the board.
    - Empty columns collapse to the left.
- [x] Game Over happens when there is no blastable cell left
- [x] Game progress is automatically saved in local storage. From main menu, player can either resume current game, or start a new one.
- [x] Simple screen management
- [ ] Record & replay
- [ ] AI Bot
- [ ] Score & Leveling up
- [ ] Juices (animations, music, sfx, etc)

## Architecture notes

- `core.*` objects represent the game state & logic. They are highly portable, and should work with any Haxe-based game engine, on any supported platform.
- `display.*` objects use OpenFL APIs to render gameplay, UIs, and handle player input.
- Example:
    - `core.Board` object contains board state, allow mutating via `tryBlast(row, col)` method, and provide observable hooks to watch for state changes.
    - `display.BoardSprite` renders a `core.Board`, and observe its changes to update visually.
