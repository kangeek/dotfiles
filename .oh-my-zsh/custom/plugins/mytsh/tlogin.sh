#!/usr/bin/zsh

TELE_PROXY="jump.kang.zone:8443"
TELE_USERNAME="kang"
TELE_PASSWORD=$(op read "op://Homelab/jump.kang.zone/password")
TELE_OTP_CODE=$(op read "op://Homelab/jump.kang.zone/one-time password?attribute=otp")

/usr/bin/expect <<-EOF
  spawn tsh login --user $TELE_USERNAME --proxy=$TELE_PROXY
  
  expect "Enter password for Teleport user $TELE_USERNAME:"
  send -- "${TELE_PASSWORD}\r"
  
  expect "Enter your OTP token:"
  send -- "${TELE_OTP_CODE}\r"
  
  expect eof
EOF
