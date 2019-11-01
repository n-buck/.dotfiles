#!/bin/bash

f=$1
OutputFilename="${f%.*}.txt"
Prefix="{\"lyric\":\""
Suffix="\",\"err\":\"none\"}"

ArtistName="$(ffprobe -i "$1" 2>&1 | grep -i '  ARTIST' | cut -b 23- | sed 's/ /%20/g')"
TrackName="$(ffprobe -i "$1" 2>&1 | grep -i '  TITLE'  | cut -b 23- | sed 's/ /%20/g')"

Url="http://lyric-api.herokuapp.com/api/find/$ArtistName/$TrackName/"

Lyrics="$(curl -s $Url | sed 's/\\n/\n/g' | sed 's/\\"/"/g')"
if [[ $Lyrics == *"$Suffix" ]]; then
  Lyrics="${Lyrics#$Prefix}"
  Lyrics="${Lyrics%$Suffix}"
  echo "$Lyrics" > "$OutputFilename"
  echo "$OutputFilename"
fi
