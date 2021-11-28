#!/bin/bash

clear

cd /home/facskog/Projectek/Matlab/SolarStorm/images

for t in south nMagn north
do 
	echo $t
	for f in $(echo $(echo $t)*.eps.gz)
	do 
		echo $f
		gunzip $f
		gs -dSAFER -dEPSCrop -r220 -sDEVICE=ppm -o $(echo $f|cut -f1 -d.).ppm $(echo $f|cut -f1,2 -d.) > /dev/null
		gzip $(echo $f|cut -f1,2 -d.)
	done
	convert -delay 6 -quality 95 $(echo $t)*.ppm $(echo $t).mpeg
	rm $(echo $t)*.ppm
done
