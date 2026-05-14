function tlogin() {
  zsh ~/.config/zsh/mytsh/tlogin.sh
}

function tssh() {
  tsh status &> /dev/null || tlogin
  if [ "$(tsh ls -f json)" = "[]" ]; then
    echo "No available nodes."
    return 1
  fi
  target=$(tsh ls -f text | tail -n +3 | fzf --height 25% --layout=reverse --border | awk '{print $1}')
  [ -n "$target" ] && tsh ssh kang@$target
}

function tkube() {
  tsh status &> /dev/null || tlogin
  if [ "$(tsh kube ls -f json)" = "[]" ]; then
    echo "No available kube clusters."
    return 1
  fi
  target=$(tsh kube ls -f text | tail -n +3 | fzf --height 25% --layout=reverse --border | awk '{print $1}')
  [ -n "$target" ] && tsh kube login $target
}
