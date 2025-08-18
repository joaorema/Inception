#!/bin/bash

get_uptime() {
  start_ticks=$(cut -d' ' -f22 /proc/1/stat)
  current_ticks=$(cut -d' ' -f22 /proc/self/stat)
  uptime_seconds=$(( (current_ticks - start_ticks) / 100 ))
  echo "$uptime_seconds seconds"
}

while true; do
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n\
Container Hostname: $(hostname)\n\
Date: $(date)\n\
Uptime: $(get_uptime)" | nc -l -p 8000 -q 1;
done



