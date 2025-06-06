<img src="git_assets/banner.gif" alt="ReCoil" width="960"/>

## IMPORTANT:

I am moving this repo from github to codeberg, and will eventually remove the github repo in the near future.
For now, the github repo will act as a mirror for the codeberg one.
All pull requests and bug reports should be done on codeberg, which can be found [here](https://codeberg.org/rjust/ReCoil/src/branch/devel). 

## A simple arcade shooter in zero-gravity.

Shoot through waves of different enemy types and manage your velocity through a small but fun 0-gravity shooter!
You can't move on your own, so you need to rely on the recoil of your shotgun to move!
Just be sure you don't shoot too much, or you will bounce around wildy out of control.

# Controls

This game has very simple controls:

- Use your mouse to aim
- Use z and x to increase and decrease the angle.
- Click to shoot

# Features

## V0.9.2 includes:

- 3 different enemy types
- Dynamic music progression by SpicyPuddin
- Simple art with shapes, ~~beautified by a nice shader by pend00 on godotshaders.com~~ <mark>NOTE:</mark> The shader has been temporarily disabled to test out a different style.
- Scaling difficulty

## Planned for v1.0:

- [x] more enemy types 

- [ ] immovable appearing walls for more map complexety

- [x] highscore counter

- [ ] some small UI tweaks

- [ ] More Options!
  
  - [ ] shader toggling
  
  - [ ] "Hell mode", making your own bullets hurt you

## Planned for future updates:

- Add more settings
  - Controls remapping
  - 
- Modifiers to mkae the game easier/harder

# Installation

On nixos, if you use flakes, this repo has one.
You can test it out by running `nix run "git+https://codeberg.org/rjust/ReCoil`.

You can also install it by adding the flake to your system's `flake.nix` inputs.

For non-NixOs linux systems, you can get the latest release ![here](https://github.com/RafaelJust/ReCoil/releases/latest).
Note that at the moment, only linux and Windows builds are made. If you want to play this game on MacOS, you need to compile it yourself.
Please report bugs ![at the github issues page](https://github.com/RafaelJust/ReCoil/issues/new?template=bug_report.md). You can also add feature requests there.

# Contributing / building

This game is made using godot, so you need to install it if you haven't.
I will look at all PR's made, so feel free to add your Ideas to it.

# License

This project uses a ![GPL-v3 License](https://github.com/RafaelJust/ReCoil/blob/master/COPYING). 
