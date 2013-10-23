#!/bin/bash

# source image selector; default is all files in folder
filesToSpritify='*' # -p

# destination image name; default is 'output'
outputFilename='output' # -o

# destination image file format; defaults to PNG
outputFormat='png' # -f

# path from this script to the desired output file destination; defaults to ./spritify/output/images
outputImagepath='output/images' # -d

# path from this script to the desired CSS output file destination; defaults to spritify/output/css
outputCSSpath='output/css' # -h

# path from this script to the desired JSON output file destination; defaults to spritify/output/json
outputCSSpath='output/json' # -j

# background image to use in sprite frames; default no background (implemented using a blank png)
tile='blank.png' # -t

# path from the location of the css directive to the image location 
# (i.e. from outputCSSpath to outputImagepath); 
# defaults to '../css' as in the spritify/output structure
cssPath='./' # -c

# Read input parameters
while getopts "p:o:f:d:h:j:t:c:" opt
do 
    case "$opt" in 
	p) 
	    filesToSpritify=$OPTARG
	    ;;
	o) 
	    outputFilename=$OPTARG
	    ;;
	f) 
	    outputFormat=$OPTARG
	    ;;
	d) 
	    outputImagepath=$OPTARG
	    ;;
	h) 
	    outputCSSpath=$OPTARG
	    ;;
	j) 
	    outputJSONpath=$OPTARG
	    ;;
	t) 
	    tile=$OPTARG
	    ;;
	c) 
	    cssPath=$OPTARG
	    ;;
	?) 
	    exit
	    ;;
    esac
done

# some default values
let width=0;
let totalWidth=0;
let height=0;
let b=0;

# read output from feh, awk the dimensions, iterate
for dims in `feh -l $filesToSpritify | awk '{gsub(/\t+/,",")}1' | cut -d, -f3,4`
  do
    # split the width / height
    IFS=","; dima=($dims)
    let w=0; w=${dima[0]}
    let h=0; h=${dima[1]}
    # if numeric (header line sends letters, so ignore)
    if [ `echo $w | grep -o '^[0-9]*$'` ] 
    then
	# in the event that the input images are of variable size, track the largest dimensions
	if [ $h -gt $height ]; then let height=$h; fi;
	if [ $w -gt $width ]; then let width=$w; fi;
	# count the images
	let b=$b+1
    fi
done

cssProps='';
d=0;
while [ "$d" -lt $b ]
do 
    bp=$(((d * width)))
    ((d++))
    cssProps=$cssProps.$outputFilename".frame"$d" {\n \
    background-image: url("$cssPath"/"$outputFilename"."$outputFormat");\n \
    background-position:-"$bp"px 0;\n \
    background-color: transparent;\n \
    display: block;\n \
    overflow: hidden;\n \
    width: "$width"px;\n \
    height: "$height"px;\n \
    }\n";
done

echo $cssProps

# check we actually found valid images with widths and heights
if [ "$height" -gt "0" -a "$b" -gt "0" ]
then    

    # build output image file path and name
    destinationImageFile="$outputImagepath"/"$outputFilename"."$outputFormat"
    # remove previous image, if it exists
    if [ -e $destinationImageFile ]; then `rm "$destinationImageFile"`; fi
    # remove previous CSS fragment if it exists
    destinationCSSFile="$outputCSSpath"/"$outputFilename".css
    if [ -e $destinationCSSFile ]; then `rm "$destinationCSSFile"`; fi

    echo -e "Starting to generate image: $destinationImageFile which will be $width x $height pixels in size."

    `montage -verbose "$filesToSpritify" -tile "$b"x1 -geometry "$width"x"$height"+0+0 -background Transparent -texture "$tile" $destinationImageFile`

    echo -e "... done"

    echo -e "Going to create a CSS fragment"


    if [ `echo touch "$outputCSSpath"/"$outputFilename".css` ]
    then
	echo -e $cssProps > "$outputCSSpath"/"$outputFilename".css
    else
	echo "... failed to create CSS fragment, sorry."
	echo "You can copy and paste the following fragment into your HTML doc"
	echo $cssProps
   fi

    echo "done"
fi
