#!/bin/bash

stop_price=4 # stop above this price
start_price=2 # start below this price
file=/path/to/current.yaml
link=https://api.awattar.de/v1/marketdata/current.yaml

function download_data { 
  wget $link -O $file; 
  if test -f "$file"; then
    echo "$file downloaded"
  else
    echo "could not get prices"
    exit 1
  fi
}
function get_current_price { current_price=$(sed -n $((2*$(date +%-H)+39)){p} $file | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | tail -n1); }
function get_current_day { current_day=$(sed -n 3{p} $file | grep -Eo '[0-9]+'); }

# test if data file exists
if test -f "$file"; then
  echo "$file exists"
  # test if data is current
  get_current_day
  if [ "$current_day" = "$(date +%-d)" ]; then
    echo "Awattar data is up to date"
  else 
    echo "Awattar data is outdated, fetching new data"
    rm $file
    download_data
  fi
else # data file does not exist
  download_data
fi

get_current_price
echo "current price is" $current_price
if (( $(echo "$stop_price < $start_price" |bc -l) )); then
  echo "stop price cannot be lower than start price"
  exit 1
fi
if (( $(echo "$start_price > $current_price" |bc -l) )); then
  echo "starting boinc"
  boinccmd --set_run_mode auto
fi
if (( $(echo "$stop_price < $current_price" |bc -l) )); then
  echo "stopping boinc"
  boinccmd --set_run_mode never
fi
