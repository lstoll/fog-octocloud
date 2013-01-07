#!/usr/bin/expect

set password [lrange $argv 0 0]
set cmd [lrange $argv 1 1]
set rest [lrange $argv 2 20]

eval spawn $cmd $rest

set timeout 60
expect "*assword: " {
  send "$password\r"
} timeout {
  send_user "Error connecting"
}

expect eof
