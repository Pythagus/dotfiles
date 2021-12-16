# My dotfiles
This repository contains my Linux configurations with scripts to automatically load the configs into the system.

## How to use
The `scripts` folder contains multiple scripts that can be called using the `Makefile` file. Please, **don't directly call the script**.
- `make update-git` : this script update the Git `config` folder by copying the current system configs into the folder. If the script failed, you can still call the `make update-revert` command.
