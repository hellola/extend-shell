# hook functions
function _extend_chpwd {
  extend-shell sync $(pwd)
  source /opt/extend/*.zsh
}

function _extend_hist {
  echo "extend-shell history add \"$1\"" >> ~/.test
  extend-shell history add "$1"
  return 0
}

# add hooks
add-zsh-hook chpwd _extend_chpwd
add-zsh-hook zshaddhistory _extend_hist

# source current extend
source /opt/extend/extend.zsh
