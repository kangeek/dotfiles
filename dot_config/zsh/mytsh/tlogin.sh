#!/usr/bin/zsh

TELE_PROXY="jump.kang.zone:3443"
TELE_USERNAME="kang"
TELE_PASSWORD=$(op item get "jump.kang.zone" --reveal --fields label=password)
TELE_OTP_CODE=$(op item get "jump.kang.zone" --otp)

/usr/bin/expect <<-EOF
  spawn env TERM=dumb tsh login --user $TELE_USERNAME --proxy=$TELE_PROXY
  
  expect "Enter password for Teleport user $TELE_USERNAME:"
  send -- "${TELE_PASSWORD}\r"
  
  expect "Enter your OTP token:"
  send -- "${TELE_OTP_CODE}\r"
  
  expect eof
EOF
