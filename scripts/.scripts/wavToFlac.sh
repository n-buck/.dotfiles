#!/usr/bin/env bash

f=$1
OutputFilename="${f%.*}.flac"

sox $f $OutputFilename
