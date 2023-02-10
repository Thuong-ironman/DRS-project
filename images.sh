#!/bin/bash
echo "Converting to eps"
for file in *.svg; do inkscape "$file" -E "${file%svg}eps" --export-ignore-filters --export-ps-level=3 2> /dev/null; done
echo "Moving eps to presentation folder"
mv *.eps ../Presentation/Images
echo "Moving svg images"
mv *.svg Exported_images/
