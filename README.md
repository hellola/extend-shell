# Extend Shell
## What/Why?
  Aims to make a consistent and sensible experience using mnemonic keys and aliases.
  Examples include: 
    - ffs-file-free-space
    - sr-system-restart
    - mp-music-pause
  The rationale behind using the initial letter for every word is to make tab completion heavenly in the case of aliases or functions, the alias renderer also generates an alias with just the first part: `alias ffs=ffs-file-free-space`
  Aims to centralise and streamline adding aliases or keybindings, making a setup easy to backup
  An abstraction layer for:
  - Window manager key bindings (Currently only have an SxhkdRenderer)
  - ZSH key bindings
  - Tmux key bindings
  - ZSH Aliases
  Support for same commands / aliases but on different operating systems by detecting and filtering commands by operating system
  There is initial support for directory specific aliases but needs to be refined

## Installation
  - clone the repo somewhere
  - are you using rbenv or rvm? if not you should be
  - bundle install in the rails dir
  - then run integrations/setup.sh
  - follow the instructions to ensure your profile sources the extend files
  - Install gem in `extend-clients` folder by running `rake build` and then `gem i pkg/extend-shell-{version}.gem`

## Starting
  - The current starting process is very manual, I have a script that starts things.
### The Socket Server
  `bundle exec rails r lib/scripts/extend-server`
### The rails Server 
  `bundle exec rails s -b 0.0.0.0 -p 3030`
  I've bound to 0.0.0.0 because I use the api to execute hotkeys over the network

## Usage
### Web Admin
  Open http://localhost:3030 or the port you decided to start it on above
### Console
  Use `extend-shell help` for usage.
  
## TODO
 - extend-client (extend-shell executable) is badly implemented, should be doing the command handling on the client side and sending
   a structured command to the websocket instead of it being purely a command forwarder..
 - hammerspoon renderer, chorded: http://www.hammerspoon.org/docs/hs.hotkey.modal.html
 - autohotkey renderer with chords, not sure how to do that
 - make key bindings in a category shareable / installable, for example standard git related commands
