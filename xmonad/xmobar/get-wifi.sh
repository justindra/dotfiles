#!/bin/bash
# Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>
# Copyright (C) 2014 Alexander Keller <github@nycroth.com>
# Copyright (C) 2018 Justin Rahardjo <justindra@github>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#------------------------------------------------------------------------

# Use the provided interface, otherwise the device used for the default route.
if [[ -n $BLOCK_INSTANCE ]]; then
  INTERFACE=$BLOCK_INSTANCE
else
  INTERFACE=$(ip route | awk '/^default/ { print $5 ; exit }')
fi

#------------------------------------------------------------------------

# As per #36 -- It is transparent: e.g. if the machine has no battery or wireless
# connection (think desktop), the corresponding block should not be displayed.
[[ ! -d /sys/class/net/${INTERFACE} ]] && exit

#------------------------------------------------------------------------

if [[ ! -d /sys/class/net/${INTERFACE} ]]; then
  NO_WIFI=true
else
  NO_WIFI=false
fi

if [[ "$(cat /sys/class/net/$INTERFACE/operstate)" = 'down' ]]; then
  echo "No Connection Detected" # full text
  echo "No Connection Detected" # short text
  echo \#FF0000 # color
  exit
fi

#------------------------------------------------------------------------

QUALITY=$(grep $INTERFACE /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')

#------------------------------------------------------------------------

case $1 in
  -4)
    AF=inet ;;
  -6)
    AF=inet6 ;;
  *)
    AF=inet6? ;;
esac

# if no interface is found, use the first device with a global scope
IPADDR=$(ip addr show $IF | perl -n -e "/$AF ([^\/]+).* scope global/ && print \$1 and exit")

#------------------------------------------------------------------------

SSID_NAME=$(iwgetid -r)

# You can put any urgent name so the block will give warning
# if a network with this name is used, like public wifi or alike.
# You can separate multiple values with \|
URGENT_VALUE=""

if [[ ! ${SSID_NAME} ]]; then
  NO_WIFI=true
else
  NO_WIFI=false
fi

#------------------------------------------------------------------------

# Echo out [ SSID (ip.addr.here) ]

FULL_TEXT=""
COLOR="#FFFFFF"
ICON="\uf1eb"
# color
if [[ $QUALITY -ge 80 ]]; then
    COLOR="#00FF00"
    ICON="\uf1eb"
elif [[ $QUALITY -lt 80 ]]; then
    COLOR="#FFF600"
    ICON="\uf6ab"
elif [[ $QUALITY -lt 60 ]]; then
    COLOR="#FFAE00"
    ICON="\uf6ab"
elif [[ $QUALITY -lt 40 ]]; then
    COLOR="#FF0000"
    ICON="\uf6aa"
fi

if [[ "$NO_WIFI" = false ]]; then
    FULL_TEXT="<fc=${COLOR}><fn=1>${ICON}</fn>${SSID_NAME} (${IPADDR})</fc>"
else
  if [[ ! ${IPADDR} ]]; then
    FULL_TEXT="<fc=red><fn=1>\uf6ac</fn>No Network Detected</fc>"
  else
    FULL_TEXT="<fc=${COLOR}>${IPADDR}</fc>"
  fi
fi

echo -e "${FULL_TEXT}"
echo "${FULL_TEXT}"

case $BLOCK_BUTTON in
  3) echo -n "$IPADDR" | xclip -q -se c ;;
esac

if [[ "${SSID_NAME}" != "" ]]; then
  if [[ "${URGENT_VALUE}" != "" ]] && [[ $(echo "${SSID_NAME}" | grep -we "${URGENT_VALUE}") != "" ]]; then
    exit 33
  fi
fi
