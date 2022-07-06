#!/bin/bash
function handle_server() {
  # download ssprobe-server and config.yaml if not exists
  if [ ! -f ssprobe-server ] or [! -f config.yaml]; then
    wget -O ssprobe-server https://download.onezol.com/public/ssprobe/ssprobe-server
    wget -O config.yaml https://download.onezol.com/public/ssprobe/config.yaml
    chmod +x ssprobe-server
  fi

  # kill ssprobe-server process if exists
  kill_if_exist ssprobe-server

  # run ssprobe-server
  nohup ./ssprobe-server >ssprobe.log 2>&1 &
  echo "Started with pid: $!"
}

function handle_client() {
  #  download ssprobe-client if not exists
  if [ ! -f ssprobe-client ]; then
    wget -O ssprobe-client https://download.onezol.com/public/ssprobe/ssprobe-client
    chmod +x ssprobe-client
    clear
  fi

  # kill ssprobe-client process if exists
  kill_if_exist ssprobe-client

  # read variables from console
  read -p "node name: " name
  read -p "server address[127.0.0.1]: " server
  read -p "server port[3384]: " port
  read -p "token[123456]: " token

  # default settings
  if [ -z "$name" ]; then
    name=$(hostname)
  fi
  if [ -z "$server" ]; then
    server="127.0.0.1"
  fi
  if [ -z "$port" ]; then
    port="3384"
  fi
  if [ -z "$token" ]; then
    token="123456"
  fi

  # run ssprobe-client
  nohup ./ssprobe-client --name="$name" --server="$server" --port="$port" --token="$token" >ssprobe.log 2>&1 &
  echo "Started with pid: $!"
}

# kill process if exists
# param: process name
function kill_if_exist() {
  for pid in $(pgrep "$1"); do
    kill "$pid"
  done
}

# choose server or client
read -p "Deploy server[0] or Client[1]? " option
if [ "$option" -eq 0 ]; then
  handle_server
elif [ "$option" -eq 1 ]; then
  handle_client
else
  echo "Invalid option"
fi
