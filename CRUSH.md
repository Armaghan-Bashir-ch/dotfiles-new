# Overview and Introduction

These are my `.dotfiles` for Arch Linux `Hyprland` setup, it includes my config, files, and custom scripts for `Neovim` (my editor) `hyprland`, `lazygit`, `tmux`, `zsh`, `rofi`, `waybar` `wlogout` and many others

The `.dotfiles` have been pushed publicly to github on "https://github.com/Armaghan-Bashir-ch/`dotfiles-new`", and are being updated nearly every 5 hours.

Every single file has been symlinked to their counter-part/original file/dir/script in `.config` folder, not using `stow` (since I did not knew it existed when I was synlinking the files)

## Instructions

- Read this `CRUSH.md` every singel time before doing anything.
- Do not add your attribution, when pushing or doing anything to these `dotfiles`
- Keep files and code as minimal as possible, while not compromiseing on quality and execution of the code
- When writing code, focus one one task at a time, the task handed to you by the end-user, do not start doing some side-quests midway, focus and (attempt to) do one thing on one task at one time
- When changing code be careful, and also be careful when adding code that can or does effect the code that is already in the configs, be careful
- Do your research, can search online for help, can go to tool's github page/`readme.md` file, but only if **you** can not find a solution to the problem or create a code that solves a problem
- Take time, but do **not** spit out nonsense, talk with code, and if for any instructions or things to talk about code or any kind of text should be done through comments inside of code.
- When dealing with the following directries always ask for whether to add that code directly to their files or just spit out the code for me too look at it and then choose to put it in the file:
  - `hypr`
  - `nvim/custom`
  - `ghostty`
- Use `#!/bin/bash` as the shebang in a executable bash script
- When naming directories or files, make sure to name them simply/short and make them relate to each to each other, and use consistant naming
- Do use comments to explain some really big change or something that might confuse the end-user
- scripts for any tool will be available inside of `scripts` dir in every single dir for any tool
- Use spell check in bash scripts
- Use bullet points to explain/describe anything

### Nvim

- You are only allowed to ask to look for the following directories/files inside of `/nvim`
  - `lua`
  - `todo.md` (Sometimes when I have some nvim related todo list inside of it, you should be able to detect when the todo list has already been done, and when it has not already been done)
- Inside of `lua` there are three main dirctories but there is really only one main, and only one that I will be asking you to manage/do stuff with:
  - `custom`
- inside of `custom` there is `/configs`, but that is very rarely changed, main files inside of this dir and the ones that you should definaely understand the context and nature of are:
  - `init.lua`
  - `plugins.lua`
  - `mappings.lua`
  - `chadrc.lua`
- Read and only READ these files find out about the context safe it inside of your memory and whenever I ask for someting related to it, make sure to remember that context and things about that dir. Everything that you have leared from those main 4 files should be placed here in this file in bullet points clearly
- Ask for whether or not to add comments to any file, when adding code

### hypr

- There is mainly just one main file, you can say there are two:
  - `hyprland.conf`
  - `hyprlock.conf`
  - `scripts` does not need any kind of change it is working fine.
- `hyprland.conf` is the main file, it handles every single thing about my machine, it has all the shortcuts and other stuff it is well documanted, so be careeful with this file
- `hyprlock.conf` is just for the lockscreen

$ TODO: ADD SOME OTHER STUFF HERE
