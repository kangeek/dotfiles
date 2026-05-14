function tlogin() {
  local TELE_PROXY="jump.kang.zone:3443"
  local TELE_USERNAME="kang"
  local TELE_PASSWORD=$(op item get "jump.kang.zone" --reveal --fields label=password)
  local TELE_OTP_CODE=$(op item get "jump.kang.zone" --otp)

  /usr/bin/expect <<-EOF
	spawn env TERM=dumb tsh login --user $TELE_USERNAME --proxy=$TELE_PROXY

	expect "Enter password for Teleport user $TELE_USERNAME:"
	send -- "${TELE_PASSWORD}\r"

	expect "Enter your OTP token:"
	send -- "${TELE_OTP_CODE}\r"

	expect eof
EOF
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
