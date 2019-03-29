# Extend Shell
## What/Why?

### Aims to centralise and streamline adding aliases, functions and keybindings, across systems
  
  An abstraction layer for:
  - Window manager key bindings (Currently only have an SxhkdRenderer)
  - ZSH key bindings
  - Tmux key bindings
  - ZSH Aliases
  Support for same commands / aliases but on different operating systems by detecting and filtering commands by operating system

### Aims to make a consistent, predictable and searchable experience using mnemonic keys and aliases.

  Examples include: 
  - Aliases
    - ffs-file-free-space
    - sr-system-restart
    - mp-music-pause
  - Window Manager Hotkeys uses chords (the semicolon is read as 'and then')
    - alt + m ; p (music-pause)
    - alt + s ; r (system-restart)
    
  The rationale behind using the initial letter for every word is to make tab completion heavenly in the case of aliases or functions, the alias renderer also generates an alias with just the first part: `alias ffs=ffs-file-free-space`

  There is initial support for directory specific aliases but needs to be refined
  Bash support has not been tested or tried, though theoretically should be ok. Let me know about your bash experience, we would like it to work everywhere.

### Make the terminal great again

  I love console, though the learning curve is a pain, some console commands can be really obscure and the element of least surprise is definately 
  not considered when naming console commands. _There are few conventions._ This makes introducing or teaching terminal use to someone very painful. Even if you are a console veteran there are some commands that have to be looked up repeatedly.
  This is what it could be like: (this uses the fzf_search integration)
  [![asciicast](https://asciinema.org/a/mm31usXGPLO3k6NS9t25ngAFz.svg)](https://asciinema.org/a/mm31usXGPLO3k6NS9t25ngAFz?t=6)

## Installation
  - clone the repo somewhere
  - are you using rbenv or rvm? if not you should be
  - bundle install in the rails dir
  - then run integrations/setup.sh
  - follow the instructions to ensure your profile sources the extend files
  - Install gem in `extend-clients` folder by running `rake build` and then `gem i pkg/extend-shell-{version}.gem`
  - Files are synced to `/opt/extend` for loading:
    - extend.zsh
    - window_manager.conf
    - extend_wm_search
    - extend_search

## Integrations
  These are stored in the integration folder, you have to link them manually for now:
  - Rofi integration called extend_rofi.sh
  - A dmenu integration wouldn't be much more work
  - fzf integration in `integration/fzf_search.zsh` which currently hardcodes (uegh) the search key in ZSH to Control-S (^S)

## Starting
  - The current starting process is very manual, I have a script that starts things.
### The Socket Server
  `bundle exec rails r lib/scripts/extend-server`
### The Rails Server 
  `bundle exec rails s -b 0.0.0.0 -p 3030`
  I've bound to 0.0.0.0 because I use the api to execute hotkeys over the network
  
## Configuration
You can change some default settings by using environment variables:
- Set the window manager hotkey renderer by setting `EXTEND_WM_{OS}_RENDERER_` to the name of the renderer.
- Set the database path by setting `EXTEND_DB_PATH` to the path you prefer.

## Usage
### Web Admin
  Open http://localhost:3030 or the port you decided to start it on above
### Console
  The console is used for interacting with extend via command line
  Use `extend-shell help` for usage.
  The `sync` command writes all configuration to files that are loaded by zsh, tmux, sxhkd etc
  
## TODO
 - make window manager renderer configurable
 - hammerspoon renderer, chorded: http://www.hammerspoon.org/docs/hs.hotkey.modal.html
 - autohotkey renderer with chords, not sure how to do that
 - make key bindings in a category shareable / installable, for example standard git related commands
 - add descriptions to storable commands
 - extend-client (extend-shell executable) is badly implemented, should be doing the command handling on the client side and sending
   a structured command to the websocket instead of it being purely a command forwarder..
 - Model installed applications and multiple os paths to install them:
   - chocolatey for windows
   - brew for mac
   - apt for ubuntu
   - pacman for arch

## Examples
Ideally I would like to be able to package these into categories and have it easily shared
### Extend Shell aliases
Here are some examples of aliases that I've set up for extend shell
```
extend-shell alias add extend-shell=extend-shell
extend-shell alias add extend-shell-sync=extend-shell sync
extend-shell alias add extend-shell-update=source /opt/extend/extend.zsh
extend-shell alias add extend-shell-key-add=extend-shell key add
extend-shell alias add extend-shell-key-list=extend-shell key ls
extend-shell alias add extend-shell-key-rm=extend-shell key rm
extend-shell alias add extend-shell-function-add=extend-shell func add
extend-shell alias add extend-shell-function-remove=extend-shell func rm
extend-shell alias add extend-shell-function-list=extend-shell func ls
extend-shell alias add extend-shell-alias-add=extend-shell alias add
extend-shell alias add extend-shell-alias-list=extend-shell alias ls
extend-shell alias add extend-shell-alias-remove=extend-shell alias rm
extend-shell alias add extend-shell-run-service=extend-server &
extend-shell alias add extend-shell-hotkey-add-window-manager=extend-shell key add-wm
extend-shell alias add extend-shell-hotkey-add-shell=extend-shell key add
extend-shell alias add extend-shell-hotkey-remove=extend-shell hotkey rm
extend-shell alias add extend-shell-hotkey-remove=extend-shell hotkey rm
extend-shell alias add extend-shell-alias-add-osspecific=extend-shell --os-only alias add
extend-shell alias add extend-shell-choose=cat /opt/extend/extend_search | fzf
extend-shell alias add extend-shell-hotkey-add-tmux=extend-shell key add-tmux
extend-shell alias add extend-shell-key-add-tmux-command=extend-shell key add-tmux --command
extend-shell alias add extend-shell-key-add-tmux=extend-shell key add-tmux
extend-shell alias add extend-shell-env-add=extend-shell env add
extend-shell alias add extend-shell-env-add-only=extend-shell env add -o
extend-shell alias add extend-shell-env-list=extend-shell env ls
extend-shell alias add extend-shell-exec=extend-shell key exec
extend-shell alias add extend-shell-startup-execute=extend-shell startup exec
```


### Files
```
extend-shell alias add file-line-count=wc -l
extend-shell alias add file-compress-directory=tar cvzf \$(basename $PWD).tar.gz .
extend-shell alias add file-extract-archive=tar -xf
extend-shell alias add file-free-space=df -h
extend-shell alias add file-space-usage=ncdu
extend-shell alias add file-edit=$EDITOR
extend-shell alias add file-edit-recent=fasd -e vim -f
extend-shell alias add file-search-contents=ag
extend-shell alias add file-permission-execute=chmod +x
extend-shell alias add file-contents-follow=tail -f
extend-shell alias add file-edit-search=vim $(fzf)
extend-shell alias add file-copy-contents=xclip -sel c <
extend-shell alias add file-size-max=du --max-depth 1 | sort -n
extend-shell alias add file-explorer=ranger
extend-shell alias add file-find-name=find . -iname
```
