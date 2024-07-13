# PacMan Assembly RISC-V

## Description
This project implements a game similar to PacMan using the Assembly programming language for the RISC-V architecture. The goal is to demonstrate the ability to develop a classic game in a low-level language, exploring the features of the RISC-V architecture.

## Features
- Graphical interface (Bitmap Display, 320×240, 8 bits/pixel);
- Keyboard interface (Keyboard and Display MMIO simulator);
- MIDI audio interface (ecalls 31, 32, 33);
- 2 levels with different layouts;
- Character animation and movement;
- Collision with walls and enemies (loss of life);
- Implementation of pellets scattered throughout the level and victory condition upon collecting all of them;
- Implementation of 4 enemies, each with distinct behaviors;
- Character attack mechanics and change in enemy behavior upon collecting special pellets;
- HUD (heads-up display) with information on score, level, and high score;
- Music and sound effects

## Prerequisites
To run the game, you need:
- A compatible RISC-V CPU simulator or emulator. ([FPGARS](https://leoriether.github.io/FPGRARS/) is recommended)
- A configured RISC-V Assembly development environment.

## Contribution
Contributions are welcome! Feel free to open issues to report bugs, suggest improvements, or make pull requests.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT) - see the [LICENSE](LICENSE) file for more details.

## Authors
- Élvis Miranda (@neatzzy)
- Gustavo Alves (@gusfring41)
- Pedro Marcinoni (@Liferoijrm)

---

Have fun playing PacMan in RISC-V Assembly! 🎮
