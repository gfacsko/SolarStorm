#!/bin/bash

# Clear screen
clear

# Step into the images directory
cd /home/facskog/Projectek/Matlab/SolarStorm/images

# Create separated movies
#
# Image types
#for t in south nMagn north
#do 
        # Status report
#	echo $t
        # Handle one type of file
#	for f in $(echo $(echo $t)*.eps.gz)
#	do 
                # Status report
#		echo $f
                # Uncompress file
#		gunzip $f
                # Convert eps file to ppm
#		gs -dsafer -depscrop -r220 -sdevice=ppm -o $(echo $f|cut -f1 -d.).ppm $(echo $f|cut -f1,2 -d.) > /dev/null
                # Compress eps file
#		gzip $(echo $f|cut -f1,2 -d.)
#	done
        # Create movie
#	convert -delay 6 -quality 95 $(echo $t)*.ppm $(echo $t).mpeg
        # Delete ppm files
#	rm $(echo $t)*.ppm
#done

# Create merged movie
#
# Go through images
for d in $(ls *20010331_*.eps.gz|cut -f2 -d-|cut -f1 -d.|sort -u)
do
	# Status report
	echo $d
	# Uncompress the files
	gunzip *$(echo $d).eps.gz
	# Append ionospheric plots
        convert -density 200 -resize 47.5% -append northIonoPlot-$d.eps southIonoPlot-$d.eps mergedPolarPlot-$d.ppm
	# Append magnetospheric and ionospheric images
	convert -density 200 +append nMagnPlot-$d.eps mergedPolarPlot-$d.ppm mergedPlot-$d.ppm
        # Compress eps files
	gzip *$(echo $d).eps
	# Delete temporary file
	rm mergedPolarPlot-$d.ppm
done

# Create movie
convert -delay 6 -quality 95 mergedPlot*.ppm mergedPlot.mpeg

# Delete images
rm mergedPlot-*.ppm

# Return to the start directory
cd /home/facskog/Projectek/Matlab/SolarStorm
