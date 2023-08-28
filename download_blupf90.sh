#!/bin/bash

#------------------------------------------------------------------------------#
# Description
#------------------------------------------------------------------------------#

# This script is designed to download, move, and install the whole 
# suite of programs. 

#------------------------------------------------------------------------------#
# Check for BLUPF90 folder
#------------------------------------------------------------------------------#

if [ -e ~/bin/BLUPF90/ ]; then

	# message
	printf "\n  ~/bin/BLUPF90/ exists so I assume you have them downloaded already\n"
	printf "  If you want to download new versions, please run 'rm -Rf ~/bin/BLUPF90/'\n\n"

	# stop
	exit 0

else
	
	# message
	printf "\n  ~/bin/BLUPF90/ does not exist, I will create it now\n\n"

	# make directory to store binaries
	mkdir ~/bin/BLUPF90/

fi



#------------------------------------------------------------------------------#
# Download BLUPF90 Family of Programs
#------------------------------------------------------------------------------#

# extract the OS
os=$(uname -s)

# determine the OS
if [ "$os" = "Linux" ]; then

  printf "\n----- OS: Linux -----\n\n"

  # on Linux, add export PATH to .bashrc
  echo "export PATH=$HOME/bin/BLUPF90:$PATH" >> $HOME/.bashrc
  
  #------------------------------------------------------------------------------#
  # Download BLUPF90
  #------------------------------------------------------------------------------#
  
  # download programs for Linux
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/blupf90+
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/gibbsf90+
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/idsolf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/inbupgf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/postgibbsf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/postGSf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/predf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/predictf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/preGSf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/qcf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/renumf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Linux/64bit/seekparentf90

  # change permissions
  chmod 775 blupf90+
  chmod 775 gibbsf90+
  chmod 775 idsolf90
  chmod 775 inbupgf90
  chmod 775 postgibbsf90
  chmod 775 postGSf90
  chmod 775 predf90
  chmod 775 predictf90
  chmod 775 preGSf90
  chmod 775 qcf90
  chmod 775 renumf90
  chmod 775 seekparentf90

  # move all to ~/bin/BLUPF90/
  mv blupf90+ ~/bin/BLUPF90/
  mv gibbsf90+ ~/bin/BLUPF90/
  mv idsolf90 ~/bin/BLUPF90/
  mv inbupgf90 ~/bin/BLUPF90/
  mv postgibbsf90 ~/bin/BLUPF90/
  mv postGSf90 ~/bin/BLUPF90/
  mv predf90 ~/bin/BLUPF90/
  mv predictf90 ~/bin/BLUPF90/
  mv preGSf90 ~/bin/BLUPF90/
  mv qcf90 ~/bin/BLUPF90/
  mv renumf90 ~/bin/BLUPF90/
  mv seekparentf90 ~/bin/BLUPF90/

elif [ "$os" = "Darwin" ]; then

  printf "\n----- OS: MacOS -----\n\n"
  
  # on Mac, add export PATH to .bash_profile
  echo "export PATH=$HOME/bin/BLUPF90:$PATH" >> $HOME/.bash_profile
  
  #------------------------------------------------------------------------------#
  # Download BLUPF90
  #------------------------------------------------------------------------------#
  
  # download programs for Mac
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/blupf90+
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/gibbsf90+
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/idsolf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/inbupgf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/postgibbsf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/postGSf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/predf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/predictf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/preGSf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/qcf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/renumf90
  curl -O http://nce.ads.uga.edu/html/projects/programs/Mac_OSX/64bit/seekparentf90

  # change permissions
  chmod 775 blupf90+
  chmod 775 gibbsf90+
  chmod 775 idsolf90
  chmod 775 inbupgf90
  chmod 775 postgibbsf90
  chmod 775 postGSf90
  chmod 775 predf90
  chmod 775 predictf90
  chmod 775 preGSf90
  chmod 775 qcf90
  chmod 775 renumf90
  chmod 775 seekparentf90

  # move all to ~/bin/BLUPF90/
  mv blupf90+ ~/bin/BLUPF90/
  mv gibbsf90+ ~/bin/BLUPF90/
  mv idsolf90 ~/bin/BLUPF90/
  mv inbupgf90 ~/bin/BLUPF90/
  mv postgibbsf90 ~/bin/BLUPF90/
  mv postGSf90 ~/bin/BLUPF90/
  mv predf90 ~/bin/BLUPF90/
  mv predictf90 ~/bin/BLUPF90/
  mv preGSf90 ~/bin/BLUPF90/
  mv qcf90 ~/bin/BLUPF90/
  mv renumf90 ~/bin/BLUPF90/
  mv seekparentf90 ~/bin/BLUPF90/

elif [ "$os" = "FreeBSD" ]; then

  printf "\n----- OS: FreeBSD -----\n"
  printf "  No BLUPF90 software for FreeBSD\n\n"

else

  printf "\n\nUnknown operating system: %s \n" $os
  printf "  Please use Linux or MacOS\n\n"

fi







