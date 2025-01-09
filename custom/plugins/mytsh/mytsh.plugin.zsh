function tlogin() {
  zsh ${ZSH_CUSTOM}/plugins/mytsh/tlogin.sh
}

function tssh() {
  tsh status &> /dev/null || tlogin
  target=$(tsh ls -f text | fzf --height 25% --layout=reverse --border | awk '{print $1}')
  [ -n "$target" ] && tsh ssh ubuntu@$target
}

function tkube() {
  tsh status &> /dev/null || tlogin
  target=$(tsh kube ls -f text | fzf --height 25% --layout=reverse --border | awk '{print $1}')
  [ -n "$target" ] && tsh kube login $target
}
