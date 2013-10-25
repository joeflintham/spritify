# spritify.sh

... is a shell script which takes a series of images and creates a CSS sprite - a single image and a CSS fragment which can be used to control the display of the sprite.

## why?

I recently found myself working on a parallax site with a requirement for a number of frame-based animations - 15 of them in fact. I couldn't face pushing marching ants around Photoshop all day long so wrote this script instead.

## usage

$ chmod 777 spritify.sh  
$ ./spritify.sh [options]  

A demo is included in the repository. Make ./demo.sh executable and it will turn the source images (see in ./demo/source/) into a sprite. Point your browser at ./demo/index.html and you can see the sprite being animated (10 frames / second).

## options

* -p: source image selector; default is all files in folder;  
* -o: destination image name; default is 'output'  
* -f: destination image file format; defaults to PNG  
* -d: path from this script to the desired output file destination; defaults to ./spritify/output/images  
* -h: path from this script to the desired CSS output file destination; defaults to spritify/output/css  
* -j: path from this script to the desired JSON output file destination; defaults to spritify/output/json  
* -t: background image to use in sprite frames; default no background (implemented using a blank png)  
* -c: path from the location of the css directive to the image location; defaults to '../css' as in the spritify/output structure  

## todo

* more verbose readme.md  
* JSON output for easier build integration  