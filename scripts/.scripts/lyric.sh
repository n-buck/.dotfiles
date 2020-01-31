#!/bin/bash

f=$1
output_filename="${f%.*}.txt"
prefix="{\"lyric\":\""
suffix="\",\"err\":\"none\"}"

artist_name="$(ffprobe -i "$1" 2>&1 | grep -i '  ARTIST' | cut -b 23- | sed 's/ /%20/g')"
track_name="$(ffprobe -i "$1" 2>&1 | grep -i '  TITLE'  | cut -b 23- | sed 's/ /%20/g')"

url="http://lyric-api.herokuapp.com/api/find/$artist_name/$track_name/"

lyrics="$(curl -s $url)"
lyrics=$(echo $lyrics | php -R  'echo html_entity_decode($argn);' | sed 's/\\n/\n/g' | sed 's/\\"/\"/g')

if [[ $lyrics == *"$suffix" ]]; then
  lyrics="${lyrics#$prefix}"
  lyrics="${lyrics%$suffix}"
  echo "$lyrics" > "$output_filename"
  echo "$output_filename"
fi
