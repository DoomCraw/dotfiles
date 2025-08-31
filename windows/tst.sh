#!/bin/bash

trap SIGTERM 'rm -f /tmp/$0.lock'

test -f /tmp/$0.lock &&
  kill -0 $(</tmp/$0.lock) && {
  kill -s SIGTERM $(</tmp/$0.lock)
  wait $(</tmp/$0.lock)
  echo $$ >/tmp/$0.lock
}

main() {
  sleep 10000
}

main $@
