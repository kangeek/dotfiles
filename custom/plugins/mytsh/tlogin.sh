#!/usr/bin/zsh

TELE_PROXY="jump.jihulab.net:443"
TELE_USERNAME="kangliu"
TELE_PASSWORD=$(op read "op://Employee/o5rajpl7ozhohvnl3friho5gza/password")
TELE_OTP_CODE=$(op read "op://Employee/o5rajpl7ozhohvnl3friho5gza/Section_zdq5sm56j24np2mxs3jmik7yzi/TOTP_75508179861D415FB6E689BF613B7009?attribute=otp")

/usr/bin/expect <<-EOF
  spawn tsh login --user $TELE_USERNAME --proxy=$TELE_PROXY
  
  expect "Enter password for Teleport user $TELE_USERNAME:"
  send -- "${TELE_PASSWORD}\r"
  
  expect "Enter your OTP token:"
  send -- "${TELE_OTP_CODE}\r"
  
  expect eof
EOF
