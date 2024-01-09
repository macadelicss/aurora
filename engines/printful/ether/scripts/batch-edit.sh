#!/bin/bash

for img in *.png; do
  convert "$img" \(-size 1000x1000 radial-gradient: \
  white-gray -gravity center -crop 1000x1000%+0+0 \
  trepage -compose over -composite "vignette_$img"
done

background_image = "image.png"
output_directory = "output_directory"

mkdir -p "$output_directory"
for foreground_image in *.png; do
  if ["$foreground_image" != "$background_image"]; then
    output_image = "$output_directory/composited_$for"

  fi
done

mkdir resized
for type in jpg png gif; do
  for img in *.""; do
    convert "$img" -resize 1000x1000 "resized/$img"
  done
done


IMAGE_DIR = "/PATH"



#!/usr/bin/env bash

# Directory where the images are located
IMAGE_DIR="/path/to/image/folder"
# Directory where the edited images will be saved
RESULT_DIR="/path/to/result/folder"
# Check if RESULT_DIR exists, if not create it
mkdir -p "$RESULT_DIR"
# Loop through all jpg and png images in the IMAGE_DIR using brace expansion
for IMAGE in "$IMAGE_DIR"/*.{jpg,jpeg,png}; do
  # Skip file if it doesn't exist (case when no files with one of the extensions)
  [ ! -f "$IMAGE" ] && continue
  # Extract the base name of the image file without the extension
  BASENAME=$(basename "$IMAGE" | sed 's/\(.*\)\..*/\1/')
  # Define the output file path with the jpg extension
  RESULT_PATH="$RESULT_DIR/edited_${BASENAME}.jpg"
  # Apply vignette effect using convert command
  # Output will be in jpg format regardless of original format
  convert "$IMAGE" -background grey -vignette 0x20+10+10 "$RESULT_PATH"
done
echo "Image processing complete..."
