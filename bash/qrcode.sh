#!/bin/bash
#
# A script to genenrate your network's QR code.
#
# Requires `qrencode` to be installed on your Mac.
# You can install it using brew
# `brew install qrencode`

usage() {
  echo """Usage: <command> options:<s|p|d>
  Arguments:
   -s     The name of the network (i.e. ssid)
   -p     Network password
   -d     The output directory for the QR code
  """
  exit 2
}

if ! command -v qrencode &> /dev/null: then
  echo "'qrencode' is required!"
  exit 0
fi

while getopts ":hs:p:d:" opt; do
  case ${opt} in
    s )
      ssid="${OPTARG}"
      ;;
    p )
      password="${OPTARG}"
      ;;
    d )
      directory="${OPTARG}"
      ;;
    h | : | * )
      usage
      ;;
  esac
done

if [[ ${OPTIND} == 1 ]]; then
  usage
fi
shift $((OPTIND -1))

echo "Generating QR code for SSID '${ssid}' in directory '${directory}'"
echo "Password selected is: \"${password}\""

qrencode -o ${directory}/${ssid}.png "WIFI:T:WPA2;S:${ssid};P:${password};;"
if [[ $? -eq 0 ]]; then
  echo "Successfully generated '${ssid}.png'"
else
  echo "Failed to generate the QR code"
fi
