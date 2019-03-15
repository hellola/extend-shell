#!/bin/sh
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "sudo is required"
    exit
fi

echo "making extend db folder"
sudo mkdir -p /opt/extend/db
echo "ensuring the extend folder is owned by $SUDO_USER"
sudo chown ${SUDO_USER}:${SUDO_USER} /opt/extend -R

# link integrations
# TODO: Integrate other integration scripts here

echo "To ensure you are loading extend aliases and fzf search run this command with your respective terminal profile file:"
echo "echo \"# load extend\n. /opt/extend/extend.zsh \n. /opt/extend/fzf_search.zsh\" >> ~/.zshrc"
echo "To make sure the tmux hotkeys are loaded run:"
echo "echo \"# load extend tmux\nsource-file /opt/extend/tmux.conf\" >> ~/.tmux.conf"

