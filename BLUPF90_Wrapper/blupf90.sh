#!/bin/bash

#====================================================================================================#
# blupf90v2.0.sh
#====================================================================================================#

# Author:      Austin Putz [putz (dot) austin (at) gmail (dot) com]
# Created:     Long time ago (maybe 2014)
# Edited:      Sept 16, 2018
# License:     GPLv2

#====================================================================================================#
# Description
#====================================================================================================#
# 
# UPDATE: for version 2.x
# 
# Note: this is a major revision to this shell script. 
# 
# Trying to make it not loop through all columns, just use the parameter files given,
# extract the trait names, search and replace with the parameter file
# 
# TO DO:
# 	- Also if I can run the analyses within the export directory (OutputDir/Trait1/..)
# 
#====================================================================================================#
# Set working directory
#====================================================================================================#

# set current working directory
current_wd=`pwd`

# move into current working directory
cd $current_wd

# print messages
printf "\nBEGIN\n"
printf "\n\tStarting analysis on `date`\n"

#====================================================================================================#
# Options
#====================================================================================================#

# Options you can specify
# 	-a		= application program
# 	-p		= parameter file
#				make sure "trait1" are specified in the parameter file under TRAITS
# 	-pd		= parameter file directory
# 	-d		= data file
# 	-h		= header file (default name is "header")
# 	-b		= basename for output files
# 	-m 		= missing observation
# 	-o		= output directory
# 	-acc	= get accuracies using accf90
# 	-gs		= genomic script (changes accf90 to accf90GS and naming of files)

#====================================================================================================#
# How it works!
#====================================================================================================#

# 1. Place all your parameter files in a folder within whatever working directory you want
# 
# 		Format 1 trait : basename.trait1.par
#		Format 2 trait : basename.trait_1.trait_2.par
#		Format 3 trait : basename.trait_1.trait_2.trait_3.par
#
# 	trait1 = column name for trait 1
#   trait2 = column name for trait 2
#   trait3 = column name for trait 3
# 
#	 these must link to the header file you give this shells script
# 
# 2. In those parameter files add "data.dat" to the line below 'DATAFILE' keyword. 
# 		- It will replace this keyword with the subset dataset you need (removing missing of both fields)
# 
# 3. 
# 

#====================================================================================================#
# Set Options
#====================================================================================================#

# set defaults
acc=0
gs=0
Overwrite_Output_Directory=0
Max_Rounds=500
Ped_Depth=3

gnuplot_script=~/plot_conv.gnuplot

#----------------------------------------------------------------------------------------------------#
# Set from input values
#----------------------------------------------------------------------------------------------------#

# loop through all positional variables to set variables
if [ -z $1 ]; then        # check to see if any options are even given

	# Print usage if nothing is specified
	printf "\nUsage: blupf90.x.x.sh -a [program] -s [number] -e [number] -pd [dir with files] etc...\n" 1>&2

	printf "\nOptions:\n" 1>&2
	printf "\t-a     = application program (remlf90, airemlf90, gibbs2f90, thrgibbs1f90)\n" 1>&2
	printf "\t-s     = starting column of response variables\n" 1>&2
	printf "\t-e     = ending column of response variables\n" 1>&2
	printf "\t-p     = parameter file\n" 1>&2
	printf "\t-pd    = parameter file directory\n" 1>&2
	printf "\t-d     = data file\n" 1>&2
	printf "\t-h     = header file\n" 1>&2
	printf "\t-b     = basename for files\n" 1>&2
	printf "\t-m     = missing value in dataste\n" 1>&2
	printf "\t-o     = output directory\n" 1>&2
	printf "\t-n     = cell phone number to text when each analysis completes\n" 1>&2
	printf "\t-acc   = calculate accuracy with accf90\n" 1>&2
	printf "\t-gs    = genomic selection with single-step\n" 1>&2
	printf "\t-ns    = number of samples\n" 1>&2
	printf "\t-bi    = burn-in\n" 1>&2
	printf "\t-st    = store every __ samples\n" 1>&2

	printf "\nKeywords: \n" 1>&2
	printf "\t1) 'file.dat' (datafile to replace, place below DataFile keyword in par file)\n" 1>&2 
	printf "\t2) 'trait1' (single trait, place below TRAITS keyword in par file)\n" 1>&2
	printf "\t3) 'trait1 trait2' (in bivariate analyses)\n\n" 1>&2

	printf "Please see my GitHub for more: https://github.com/austin-putz/BLUPF90/tree/master/BLUPF90_Wrapper\n\n" 1>&2

 	exit 1

else
 	while [[ $# -gt 0 ]]; do 
 		case $1 in

		# set all the variable values
			-a)     shift
					program=$1				# application program to be used
					;;
			-p)		shift
					ParFile=$1				# sets the generalized parameter file
 					;;
			-pd)	shift
					ParFile_Directory=$1    # parameter file directory
					;;
			-em)    shift
					EM_Rounds=$1            # set number of EM Rounds (substituted in par file)
					;;
			-mr)    shift
					Max_Rounds=$1
					;;
 			-d)		shift
 					DataFile=$1				# sets the overall data set
 					;;	
			-ped)   shift
					PedFile=$1              # set pedigree file name
					;;
			-pedd)  shift
					Ped_Depth=$1            # set pedigree depth (default 3, 0 to load whole pedigree)
					;;
			-gen)   shift
					GenFile=$1              # set genotype file name
					;;
			-map)   shift
					MapFile=$1              # set map file name
					;;
			-cov)   shift
					covar=$1                # set covariance to put in (typically a small value like 0.000001)
					;;
			-h) 	shift
					HeaderFile=$1			# specifies column names all on a separate line!
					;;
			-b)     shift
					basename=$1				# used to be filenamebase --> basename
					;;
			-m) 	shift
					missing=$1				# set missing value
					;;
			-o)		shift
					Output_Directory=$1		# Output directory
					;;
			-ow)    Overwrite_Output_Directory=1    # if '1', then overwrite the output directory
					;;
			-n)		shift
					cell=$1					# Cell phone number to text
					;;
			-acc)   acc=1					# logical, then accf90 will be ran
					;;
			-gs)    gs=1					# logical to turn on genomic selection
					;;
			-ns)	shift
					n_samples=$1			# number of sample for thrgibbs1f90
					;;
			-bi)	shift
					burnin=$1				# burn-in for thrgibbs1f90
					;;
			-st)	shift
					store=$1				# store every ___ samples of gibbs samples
					;;
 			*)		printf "\n\tInvalid option, try again\n\n" >&2  # any options not recognized will get an error message
 					exit 1
 					;;
 		esac
 		shift
	done
fi

#====================================================================================================#
# Print current date and time
#====================================================================================================#

	# print parameter file directory
	printf "\n\tParameter folder:\t%s\n" $ParFile_Directory

#====================================================================================================#
# This will check for options in the program, make sure they are correct before starting
#====================================================================================================#

#====================================================================================================#
# Application program: Look for them as binaries
#====================================================================================================#

printf "\nBLUPF90 PROGRAMS\n"

printf "\n\tCHECK: Make sure programs are named correctly and can be found in your PATH variable\n"
printf "\t\tYou can set the PATH in your .bash_profile or .bashrc file\n"

# find path for renumf90
PATH_renumf90=`which renumf90`

# send error if not found
if [[ -z $PATH_renumf90 ]]; then

	printf "\n\tERROR: renumf90 program not found. Make sure it's named correctly and in your PATH.\n\n" >&2
	exit 1

else

	# print message I found it
	printf "\n\tFound the renumf90 program in your PATH!\n"

fi

# check for individual programs (print error if not found with a PATH)
if [[ $program == airemlf90 ]]; then

	# try to find airemlf90
	PATH_airemlf90=`which airemlf90`

	# send error if not found
	if [[ -z $PATH_airemlf90 ]]; then
	
		printf "\n\tERROR: airemlf90 program not found. Make sure it's named correctly and in your PATH.\n\n" >&2
		exit 1
	
	else
	
		# print message I found it
		printf "\n\tFound the airemlf90 program in your PATH!\n"

	fi

elif [[ $program == remlf90 ]]; then

	# try to find remlf90
	PATH_remlf90=`which remlf90`

	# send error if not found
	if [[ -z $PATH_remlf90 ]]; then
	
		printf "\n\tERROR: remlf90 program not found. Make sure it's named correctly and in your PATH.\n\n" >&2
		exit 1
	
	else
	
		# print message I found it
		printf "\n\tFound the remlf90 program in your PATH!\n"

	fi

elif [[ $program == thrgibbs1f90 ]]; then

	# try to find thrgibbs1f90
	PATH_thrgibbs1f90=`which thrgibbs1f90`

	# send error if not found
	if [[ -z $PATH_thrgibbs1f90 ]]; then
	
		printf "\n\tERROR: thrgibbs1f90 program not found. Make sure it's named correctly and in your PATH.\n\n" >&2
		exit 1
	
	else
	
		# print message I found it
		printf "\n\tFound the thrgibbs1f90 program in your PATH!\n"

	fi

elif [[ $program == gibbs2f90 ]]; then

	# try to find gibbs2f90
	PATH_gibbs2f90=`which gibbs2f90`

	# send error if not found
	if [[ -z $PATH_gibbs2f90 ]]; then
	
		printf "\n\tERROR: gibbs2f90 program not found. Make sure it's named correctly and in your PATH.\n\n" >&2
		exit 1
	
	else
	
		# print message I found it
		printf "\n\tFound the gibbs2f90 program in your PATH!\n"

	fi

else 

	printf "\n\tIt appears all BLUPF90 programs have been found that are needed.\n"

fi

if [[ acc == 1 ]]; then

	# try to find both accf90 and accf90GS
	which_accf90=`which accf90`
	which_accf90GS=`which accf90GS`

	# test
	if [ -z $which_accf90 ] && [ $gs -eq 0 ]; then
			
		# print error
		printf "\n\tERROR: Cannot find the accf90 program anywhere. Make sure it's in your PATH.\n"
		exit 1

	elif [ -z $which_accf90GS] && [ $gs -eq 1 ] ; then

		# print error
		printf "\n\tERROR: Cannot find the accf90GS program anywhere. Make sure it's in your PATH.\n"
		exit 1

	fi

fi


#====================================================================================================#
# Application program: Look for Options
#====================================================================================================#

printf "\nAPPLICATION PROGRAM\n"

if [[ $program == airemlf90 ]] || [[ $program == remlf90 ]] || [[ $program == thrgibbs1f90 ]]  || [[ $program == gibbs2f90 ]]; then

	# Print the name of the program
	printf "\n\tApplication program used will be:\t %s\n" $program

else

	# Display error if not one of the programs
	printf "\n\tERROR: Application program not found\n\tTakes \"airemlf90\", \"remlf90\", \"thrgibbs1f90\", and \"gibbs2f90\" \n\n" >&2
	exit 1

fi

if [[ $program == airemlf90 ]]; then

	# set name of program
	app_program_name=aireml

elif [[ $program == remlf90 ]]; then

	# set name of program
	app_program_name=reml

elif [[ $program == thrgibbs1f90 ]]; then

	# set name of program
	app_program_name=thrgibbs1f90

elif [[ $program == gibbs2f90 ]]; then

	# set name of program
	app_program_name=gibbs2f90

fi


if [[ $program == thrgibbs1f90 ]] || [[ $program == gibbs2f90 ]]; then

	printf "\n\tGibbs program checks\n"

	# Check to see if all the inputs for the Gibbs sampler have been created
	if [[ ! -z $n_samples ]] && [[ ! -z $burnin ]] && [[ ! -z $store ]]; then

		printf "\n\t\tAll the options for the Gibbs sampler have been specified\n"

	else

		printf "\n\t\tERROR: One of the options needed for a Gibbs program was forgotten\n" >&2
		exit 1

	fi

	# Print what the inputs are for the gibbs sampler
	printf "\n\t\tThe number of samples:\t%s" $n_samples
	printf "\n\t\tThe burnin was:\t\t%s" $burnin
	printf "\n\t\tStore every:\t\t%s\n" $store

	# Check to see if the number of samples is within a reasonable range (not negative and less than a billion)
	if [ $n_samples -gt 1 ] && [ $n_samples -lt 10000000 ]; then

		printf "\n\t\tThe number of samples is acceptable\n"

	else

		printf "\n\t\tThe number of samples is out of bounds\n" >&2
		exit 1

	fi

	# Check to see if the burnin is within a reasonable range
	if [ $burnin -gt -1 ] && [ $burnin -lt 100000 ]; then

		printf "\n\t\tThe burn-in is acceptable\n"
	
	else

		printf "\n\t\tThe burn-in is out of bounds\n" >&2
		exit 1

	fi

	# Check to see if the number of samples to store is within range
	if [ $store -gt 0 ] && [ $store -lt 1000 ]; then

		printf "\n\t\tThe number to store every X samples is acceptable\n"

	else

		printf "\n\t\tThe number to store every X samples is out of bounds\n" >&2
		exit 1

	fi

fi

#====================================================================================================#
# Basename
#====================================================================================================#

printf "\nBASENAME\n"

# Check if basename was specified
if [ -z $basename ]; then

	# Display error if basename is not found
	printf "\n\tERROR: Basename was not found\n\n" >&2
	exit 1

else

	# Print basename
	printf "\n\tBasename being used is:\t %s\n" $basename

fi

#====================================================================================================#
# Parameter file directory
#====================================================================================================#

printf "\nPARAMETER FILE DIRECTORY\n"

# Check parameter file directory
if [ -z $ParFile_Directory ]; then

	# Display error if nothing is specified for the parameter file directory
	printf "\n\tERROR: No parameter file directory specified\n" >&2
	exit 1

elif [ ! -d $ParFile_Directory ]; then

	# Display error if it's not actually a directory
	printf "\n\tERROR: The parameter file directory specified cannot be found\n" >&2
	exit 1

else

	# Print the parameter file directory
	printf "\n\tThe parameter file directory:\t %s\n" $ParFile_Directory

fi

#====================================================================================================#
# Parameter file
#====================================================================================================#

printf "\nPARAMETER FILE\n"

# Check if there is a parameter file given (REQUIRED)
if [ -z $ParFile ]; then

  # error message if there is no parameter file specified
	printf "\n\tWARNING: No parameter file given so assuming each trait has an individual parameter file\n"

elif [ ! -e $ParFile_Directory/$ParFile ]; then

  # error message if the parmeter file is not a real file
	printf "\n\tERROR: Parameter file specified is not a file\n\n" >&2
	exit 1
	
else

	# Print the name of the parameter file
	printf "\n\tThe parameter file being used is:\t %s\n" $ParFile

fi

#====================================================================================================#
# Data file
#====================================================================================================#

printf "\nDATA FILE\n"

# Check if there is a data file given (REQUIRED)
if [ -z $DataFile ]; then

	# Sent to standard error if no data file is specified 
	printf "\n\tERROR: Need data file\n\n" >&2
	exit 1

elif [ ! -e $DataFile ]; then

	# Error message if the data file specified does not exist
	printf "\n\tERROR: Data file specified is not a file\n\n" >&2
	exit 1

else

	# print the data file
	printf "\n\tThe data file being used is:\t\t %s\n" $DataFile

	# check ped quick
	awk ' { print NF } ' $DataFile | uniq -c > data_file_columns.txt

	# check number of rows
	n_fields_uniq_data=`awk ' END { print NR } ' data_file_columns.txt`

	# check to make sure it has all the same number of columns
	if [ $n_fields_uniq_data -gt 1 ]; then

		# print error
		printf "\n\tERROR: Data file has a different number of columns in each row\n" >&2
		exit 1

	fi

fi

# check how many columns there are in the data file
n_dataset_columns=`awk ' END { print NF } ' $DataFile`
n_dataset_rows=`awk ' END { print NR } ' $DataFile`
printf "\n\tColumns in the dataset:\t\t %s\n" $n_dataset_columns
printf "\tRows in the dataset:\t\t %s\n" $n_dataset_rows

#====================================================================================================#
# Pedigree file
#====================================================================================================#

printf "\nPED FILE\n"

# Check if there is a pedigree file given (REQUIRED)
if [ -z $PedFile ]; then

	# Sent to standard error if no pedigree file is specified 
	printf "\n\tERROR: Need data file\n\n" >&2
	exit 1

# look to make sure it's a file
elif [ ! -e $PedFile ]; then

	# Error message if the data file specified does not exist
	printf "\n\tERROR: Pedigree file specified cannot be found\n\n" >&2
	exit 1

else

	# print the data file
	printf "\n\tThe pedigree file being used is:\t %s\n" $PedFile

	# check ped quick
	awk ' { print NF } ' $PedFile | uniq -c > ped_file_columns.txt

	# check number of rows
	n_rows_uniq_ped=`awk ' END { print NR } ' ped_file_columns.txt`

	# check to make sure it has all the same number of columns
	if [ $n_rows_uniq_ped -gt 1 ]; then

		# print error
		printf "\n\tERROR: Pedigree has a different number of columns in each row\n" >&2
		exit 1

	fi

fi

# check how many columns there are in the data file
n_ped_columns=`awk ' END { print NF } ' $PedFile`
n_ped_rows=`awk ' END { print NR } ' $PedFile`
printf "\n\tColumns in the pedigree:\t %s\n" $n_ped_columns
printf "\tRows in the pedigree:\t\t %s\n" $n_ped_rows

# Check pedigree depth
printf "\n\tPedigree depth set (3 default):\t%s\n" $Ped_Depth

#====================================================================================================#
# Genotype File
#====================================================================================================#

printf "\nGENOTYPE FILE\n"

# Look for genotype file
if [ -z $GenFile ]; then

	# print message that you didn't find a name for the genotype file
	printf "\n\tWarning: Didn't find a genotype file given. Assuming there isn't one.\n"

# look to make sure it's a file
elif [ ! -e $GenFile ]; then

	# print error
	printf "\n\tERROR: Genotype file specified cannot be found\n\n" >&2
	exit 1


else 

	# print name of file
	printf "\n\tThe genotype file being used is:\t %s\n" $GenFile

fi

#====================================================================================================#
# Map File
#====================================================================================================#

printf "\nMAP FILE\n"

# Look for map file
if [ -z $MapFile ]; then

	# print message that you didn't find a name for the map file
	printf "\n\tWarning: Didn't find a map file given. Assuming there isn't one.\n"

# look to make sure it's a file
elif [ ! -e $MapFile ]; then

	# print error
	printf "\n\tERROR: Map file specified cannot be found\n\n" >&2
	exit 1


else 

	# print name of file
	printf "\n\tThe map file being used is:\t\t %s\n" $MapFile

fi

#====================================================================================================#
# Covariance
#====================================================================================================#

printf "\nCOVARIANCE\n"

# check if it's specified
if [ -z $covar ]; then

	# print message if not found
	printf "\n\tDidn't find a covariance specified, will use 0.000001\n"

	# set covar
	covar=0.000001

	printf "\tCovariance is:\t %s\n" $covar

else

	# print the covariance specified
	printf "\n\tCovariance specified is:\t %s\n" $covar

fi

#====================================================================================================#
# EM_Rounds
#====================================================================================================#

printf "\nEM ROUNDS\n"

# see if the number of EM Rounds was specified
if [ -z $EM_Rounds ]; then

	# print message
	printf "\n\tDidn't find the number of EM Rounds specified (default=20)\n"

	# set EM Rounds
	EM_Rounds=20

	printf "\n\tNumber of EM-Rounds first:\t%s\n" $EM_Rounds

else

	printf "\n\tNumber of EM-Rounds specified:\t%s\n" $EM_Rounds

fi

#====================================================================================================#
# Max Rounds
#====================================================================================================#

printf "\nMAX ROUNDS\n"

# state what the number will be
printf "\n\tMax number of rounds:\t%s\n" $Max_Rounds




#====================================================================================================#
# Header file
#====================================================================================================#

printf "\nHEADER\n" 

# check if there is a header file specified in options
if [ -z $HeaderFile ]; then
	
	# Print error message for no header specified
	printf "\n\tERROR: No header file specified\n\n" >&2
	exit 1

else

	# Print the header file name
	printf "\n\tThe header file being used is:\t %s\n" $HeaderFile

fi

# Get the number of rows in the header file
n_header_rows=`awk ' END { print NR } ' $HeaderFile`

# Get the number of columns in the header file (for starting values if there are 3 columns)
n_header_cols=`awk ' END { print NF } ' $HeaderFile`

# Check to see if the number of rows in header file = number of fields in data file
if [ $n_dataset_columns -ne $n_header_rows ]; then

	# Display error message if the number of columns in the data 
	# and number of rows in the header file aren't equal
	printf "\n\tERROR: Number of columns in data frame not equal to number of lines in header file\n\n" >&2
	exit 1

fi

if [ $n_header_cols -gt 1 ]; then

	if [ $n_header_cols -eq 3 ]; then

		# starting values
		printf "\n\tThe header file number of columns (should contain starting values (e and a):\t %s\n" $n_header_cols

		# subset to only the first column of column names
		awk ' { print $1 } ' $HeaderFile > data_col_names.txt

	else
		
		# Print error message for no header specified
		printf "\n\tERROR: header file should have 3 columns if specifying starting values\n\n" >&2
		exit 1

	fi

fi

#====================================================================================================#
# Check missing value
#====================================================================================================#

printf "\nMISSING VALUE\n"

# Check if the missing value was specified
if [ -z $missing ]; then

	# Display error if missing the value
	printf "\n\tERROR: Missing value was not found.\n\n" >&2
	exit 1

else

	# Print the missing value
	printf "\n\tThe missing value specified is:\t %s\n" $missing

fi

#====================================================================================================#
# Check output directory
#====================================================================================================#

printf "\nOUTPUT DIRECTORY\n"

if [ -z $Output_Directory ]; then

	# Display error message if missing
	printf "\n\tERROR: No output directory specified\n\n" >&2
	exit 1

elif [ -d $Output_Directory ] && [ $Overwrite_Output_Directory -eq 0 ]; then

	# Display warning message
	printf "\n\tERROR: Output folder is already present and will not be overwritten\n" >&2
	exit 1

elif [ -d $Output_Directory ] && [ $Overwrite_Output_Directory -eq 1 ]; then

	# Display warning message
	printf "\n\tERROR: Output folder is already present and will be overwritten\n"

	# remove output directory
	rm -rf ./${Output_Directory}

	# make output direcotry after deleting it
	mkdir ${Output_Directory}

else

	# Print output directory
	printf "\n\tThe output directory will be created:\t %s\n" $Output_Directory

	# Create the Output_Directory
	mkdir $Output_Directory

fi

#====================================================================================================#
# Number
#====================================================================================================#

printf "\nNUMBER\n"

if [ -z $cell ]; then

	# Print message saying NO cellphone number
	printf "\n\tNo cell phone number was given. No alert will be sent when analysis is done\n"
	printf "\tThis feature has been disable for now.. Textbelt now charges money..\n"

else

	# Print message saying what the cell number is
	printf "\n\tThe cell number given is:\t %s\n" $cell
	printf "\tThis feature has been disable for now.. Textbelt now charges money..\n"

fi

#====================================================================================================#
# END OF INPUT OPTION CHECKING
#====================================================================================================#

# This marks the end of the all the checks on the input
# Now the loop will start to go through all the needed analyses











#====================================================================================================#
# This is the beginning of the actual analysis to go through and run all the analyses
#====================================================================================================#

printf "\nSTARTING ANALYSIS...\n"

#====================================================================================================#
# Round 
#====================================================================================================#

# Set starting round at 1
ROUND=1

#====================================================================================================#
# Find Parameter Files
#====================================================================================================#

# find parameter files within the parameter file directory and count
n_par_files=`find ./${ParFile_Directory} -maxdepth 1 -type f -name "*.par" | awk ' END { print NR } '`

# check to make sure it's positive
if [[ $n_par_files == 0 ]]; then
	
	# print error
	printf "\n\tERROR: I didn't find any .par files in the directory you listed.\n\n" >&2
	exit 1

else 

	# Print message saying what the cell number is
	printf "\n\tNumber of parameter files I found in the directory:\t %s\n" $n_par_files
	
fi










#====================================================================================================#
# Start Analysis
#====================================================================================================#

#====================================================================================================#
# New algorithm (v2.0) to find only those files you give in the parameter file directory
# not looping through all traits like an idiot (very slow for large datasets)
#====================================================================================================#

# begin loop through all parameter files
for parfile_path in `find ./${ParFile_Directory} -maxdepth 1 -type f -name "*.par"`; do

	# pull out parameter file name (removing the path before it)
	whole_parfile_name=`echo ${parfile_path} | cut -d"/" -f 3`

	# Specify what round it's in
	printf "\n==============================================================================================================\n"
	printf "==== Analysis %s: %s ====\n" $ROUND $whole_parfile_name
	printf "==============================================================================================================\n"

	# print date and time of current analyses
	printf "\n\t\tStarting this analysis on:\t `date`\n"

	# calculate number of rounds left
	ROUNDS_LEFT=$(( n_par_files - ROUND ))

	# Increase the round by 1 for the next round
	ROUND=$(( ROUND + 1 ))

	# print message
	printf "\n\t\tRounds left:\t\t%s" $ROUNDS_LEFT
	
	# set start time
	start_time=`date +%s`  # in seconds

	#------------------------------------------------------------------------------------------------#
	# Extract everything from the filename
	#------------------------------------------------------------------------------------------------#

	# copy paramter file to current directory to run analysis
	cp -f ${parfile_path} ${current_wd}

	# find length of file name with "." as a separator
	current_n_parts_of_filename=`echo ${whole_parfile_name} | awk -F[.] ' { print NF }'`

	# check to make sure there are at least 3 arguments
	if [[ $current_n_parts_of_filename -lt 3 ]]; then

		# print error
		printf "\n\tERROR: I found a parameter file with less than 3 parts (sep = \".\")\n" 
		continue
	
	fi

	# print length of filename separated by "." (should be > 3 at least, 3 = single trait, 4 = two trait, etc)
	printf "\n\t\tNumber of parts in current filename:\t\t%s\n" $current_n_parts_of_filename

	# get current number of traits depending on last value (n - 2)
	# thus   'mybase.trait1.trait2.par'    has 4 - 2 = 2 traits
	current_n_traits=$(expr ${current_n_parts_of_filename} - 2)

	# print how many traits are in this analysis (or should be)
	printf "\t\tNumber of traits in the current filename:\t%s\n" ${current_n_traits}
	
	# set complete
	trait_names_together=`echo ${whole_parfile_name} | cut -d"." -f 2-$(expr ${current_n_traits} + 1)`

	# print full name with all traits (for directories and other file names!)
	printf "\n\t\tName of all traits together:\t\t%s\n" $trait_names_together

	#------------------------------------------------------------------------------------------------#
	# Output Directory
	#------------------------------------------------------------------------------------------------#

	# Check for directory within the output directory
	if [ -d ${Output_Directory}/${trait_names_together} ]; then

		# print error
		printf "\n\tERROR: Outputfile directory already exists. Will make another\n"

		# set new output directory
		date_sec=`date +%s`
		trait_names_together=`echo ${trait_names_together}${date_sec}`

		# make output directory for this analysis
		mkdir ${Output_Directory}/${trait_names_together}

	else

		# make output directory for this analysis
		mkdir ${Output_Directory}/${trait_names_together}
	
	fi
	
	#------------------------------------------------------------------------------------------------#
	# Find trait positions and substitute as fixed effects
	#------------------------------------------------------------------------------------------------#
	
	# loop through all trait names and search and replace the column number in the dataset
	# that way you only have to replace the column name, not the positions each time
	# still put 0 if you don't want to fit that effect
	for ((i=1; i<=${n_header_rows}; i=i+1)); do
	
		# extract current trait from header file
		current_trait=`awk ' NR=='"$i"' { print $1 } ' data_col_names.txt`
		
		# extract current trait position from header file
		current_trait_pos=`sed -n '/^'""$current_trait""'$/{=;p}' data_col_names.txt | awk ' NR==1 { print $0 }'`
		
		# substitute variable names with positions!
		sed -i 's/^'"$current_trait"' /'"$current_trait_pos"' /g'  ${whole_parfile_name}
		sed -i 's/ '"$current_trait"' / '"$current_trait_pos"' /g' ${whole_parfile_name}
		sed -i 's/ '"$current_trait"' / '"$current_trait_pos"' /g' ${whole_parfile_name}
		sed -i 's/ '"$current_trait"'$/ '"$current_trait_pos"'/g'  ${whole_parfile_name}
		sed -i 's/^'"$current_trait"'$/'"$current_trait_pos"'/g'   ${whole_parfile_name}
	
	done
	
	#------------------------------------------------------------------------------------------------#
	# find trait names from the parameter file & the positions
	#------------------------------------------------------------------------------------------------#
	
	# loop through all traits
	for (( i=1; i<=${current_n_traits}; i=i+1 )); do
	
		# set trait i name from file name
		trait_[$i]=`echo ${whole_parfile_name} | cut -d"." -f $(expr $i + 1)`

		# set trait number (from column)
		trait_pos_[$i]=`sed -n '/^'""${trait_[$i]}""'$/{=;p}' data_col_names.txt | awk ' NR==1 { print $0 }'`

		# if trait position is empty, skip this analysis (go to next)
		if [ -z ${trait_pos_[$i]} ]; then
			
			# print error
			printf "\n\t\tERROR: Cannot find trait position in datafile (will skip this analysis):\t%s" ${trait_[$i]}
			continue

		fi
			
		# print name of trait i
		printf "\n\t\tTrait ${i} (position):\t\t\t%s (%s)\n" ${trait_[$i]} ${trait_pos_[$i]}

		# print column number of trait i
		#printf "\t\t\tColumn number for trait $i:\t%s\n" ${trait_pos_[$i]}
		
		# test
		if [[ $i == 1 ]]; then
		
			# replace the trait name with the trait position in the string from above
			#trait_pos_together=`echo ${trait_names_together} | sed 's/'"${trait_[$i]}"'/'"${trait_pos_[$i]}"'/g' `
			trait_pos_together=`echo ${trait_pos_[$i]}`
		
		else
		
			# replace the trait name with the trait position in the string from above
			#trait_pos_together=`echo ${trait_pos_together} | sed 's/'"${trait_[$i]}"'/'"${trait_pos_[$i]}"'/g' `
			trait_pos_together=`echo ${trait_pos_together} ${trait_pos_[$i]}`

		fi
		
		# find starting values in header file
		e_var_val_[$i]=`awk ' NR=='""${trait_pos_[$i]}""' { print $2 } ' $HeaderFile `
		a_var_val_[$i]=`awk ' NR=='""${trait_pos_[$i]}""' { print $3 } ' $HeaderFile `

		# print starting values
		printf "\t\tStarting values (e and a):\t\t%s and %s\n" ${e_var_val_[$i]} ${a_var_val_[$i]}

		# search and replace
		sed -i 's/e_var_'"$i"'/'"${e_var_val_[$i]}"'/g' ${whole_parfile_name}
		sed -i 's/a_var_'"$i"'/'"${a_var_val_[$i]}"'/g' ${whole_parfile_name}
			
		# if just single trait analysis
		if [ $current_n_traits -eq 1 ]; then

			# subset data without missing!
			awk '!($'"${trait_pos_[$i]}"'=='"$missing"' ) { print $0 }' $DataFile > subset.dat
	
			# check rows
			n_subset_data_rows=`awk ' END { print NR } ' subset.dat `
			
			# check to see how many rows were removed!
			nrows_removed_after_data_clean=$(expr $n_dataset_rows - $n_subset_data_rows)

			# Print number of rows removed
			printf "\n\t\tNumber of rows in original dataset:\t\t%s\n" $n_dataset_rows
			printf "\t\tNumber of rows in new dataset:\t\t\t%s\n" $n_subset_data_rows
			printf "\t\tNumber of rows after removing all missing:\t%s\n" $nrows_removed_after_data_clean

		fi
	
	done # done with loop through all traits
		
	#------------------------------------------------------------------------------------------------#
	# Get all traits together from the parameter file for names later
	#------------------------------------------------------------------------------------------------#
	
	# replace periods
	trait_pos_together=`echo ${trait_pos_together} | sed 's/\./ /g'`

	# echo
	echo -e "\n\t\tTrait positions together:\t\t${trait_pos_together}"
	
	#------------------------------------------------------------------------------#
	# Replace keywords in parameter file
	#------------------------------------------------------------------------------#
	
	# search and replace in parameter file (trait positions and other)
	sed -i 's/columns/'"${trait_pos_together}"'/g' ${whole_parfile_name}
	sed -i 's/covars/'"${covar}"'/g' ${whole_parfile_name}
	sed -i 's/EM_ROUNDS/'"${EM_Rounds}"'/g' ${whole_parfile_name}
	sed -i 's/PEDIGREE_DEPTH/'"${Ped_Depth}"'/g' ${whole_parfile_name}
	sed -i 's/MAX_ROUNDS/'"${Max_Rounds}"'/g' ${whole_parfile_name}
	
	# search and replace in parameter file (data files)
	sed -i 's/data.dat/subset.dat/g' ${whole_parfile_name}
	sed -i 's:ped.dat:'"${PedFile}"':g' ${whole_parfile_name}
	sed -i 's:genotypes.dat:'"${GenFile}"':g' ${whole_parfile_name}
	sed -i 's:map.dat:'"${MapFile}"':g' ${whole_parfile_name}

	#------------------------------------------------------------------------------#
	# Check Missing Values
	#------------------------------------------------------------------------------#

	# Check the parameter file missing value
	missing_check=`sed -n '/missing '"$missing"'/p' $basename.${trait_names_together}.par` 

	# Check the missing values in the parameter files
	if [[ -z "$missing_check" ]]; then

		# Display error if missing value was not specified correctly
		printf "\n\tERROR: Need to set missing value to %s in parameter file!\n\n" $missing  >&2
		exit 1

	else 

		# Print the missing value was correctly specified
		printf "\n\t\tThe missing value is correctly specified in the parameter file\n"

	fi 

	#------------------------------------------------------------------------------#
	# Subset to only rows with at least 1 non-missing value
	#------------------------------------------------------------------------------#

	# if more than 1 trait analysis
	if [ $current_n_traits -gt 1 ]; then
		# loop through all traits
		for (( i=1; i<=${current_n_traits}; i=i+1 )); do

			if [ $i -eq 1 ]; then

				# pull out trait column
				cut -d" " -f ${trait_pos_[$i]} ${DataFile} > response_traits.txt

				# find which lines have missing
				#awk '/'"${missing}"'/{ print NR }' response_traits.txt > nonmissing_rows.txt
				#grep -vn ''"${missing}"'' response_traits.txt | awk -F[:] ' { print $1 } ' > nonmissing_rows.txt
				awk '!($'"${trait_pos_[$i]}"'=='"$missing"' ) { print NR }' $DataFile > nonmissing_rows.txt

			else

				if [ -e nonmissing_rows_joined.txt ]; then
					
					# rename file
					mv nonmissing_rows_joined.txt nonmissing_rows.txt

				fi
		
				# pull out trait column
				cut -d" " -f ${trait_pos_[$i]} ${DataFile} > current_response_traits.txt

				# find which lines have missing
				#awk '/'"${missing}"'/{print NR}' current_response_traits.txt > missing_rows_2.txt
				#grep -vn ''"${missing}"'' current_response_traits.txt | awk -F[:] ' { print $1 } ' > nonmissing_rows_2.txt
				awk '!($'"${trait_pos_[$i]}"'=='"$missing"' ) { print NR }' $DataFile > nonmissing_rows_2.txt

				#echo -e "\nGoing to join now\n"
				# combine with first missing
				#join -1 1 -2 1 <(sort -b nonmissing_rows.txt) <(sort -b nonmissing_rows_2.txt) > nonmissing_rows_joined.txt
				#echo -e "\nAfter join\n"

				# cat lines together and get unique lines
				cat nonmissing_rows.txt nonmissing_rows_2.txt | sort | uniq > nonmissing_lines_uniq.txt

			fi

		done
		
		# join to dataset
		awk ' { print NR, $0 } ' ${DataFile} > new_dataset.txt
		
		# join
		join -1 1 -2 1 <(sort -k1,1 new_dataset.txt) <(sort -k1,1 nonmissing_lines_uniq.txt) > subset1.dat

		# remove first column
		cut -d" " --complement -f -1 subset1.dat > subset.dat

		# remove data
		rm -f subset1.dat

		# check rows
		n_subset_data_rows=`awk ' END { print NR } ' subset.dat `
		
		# check missing_rows_joined.txt file
		nrows_after_data_clean=`awk ' END { print NR } ' nonmissing_lines_uniq.txt `

		# check to see how many rows were removed!
		nrows_removed_after_data_clean=$(expr $n_dataset_rows - $nrows_after_data_clean)

		# Print number of rows removed
		printf "\n\t\tNumber of rows in original dataset:\t\t%s\n" $n_dataset_rows
		printf "\t\tNumber of rows in new dataset:\t\t\t%s\n" $n_subset_data_rows
		printf "\t\tNumber of rows after removing all missing:\t%s\n" $nrows_removed_after_data_clean
		
		# remove files
		rm -f nonmissing_lines_uniq.txt
		rm -f new_dataset.txt
		
	fi

	#------------------------------------------------------------------------------#
	# Get current time
	#------------------------------------------------------------------------------#

	# set start time
	time_after_process=`date +%s`  # in seconds

	#------------------------------------------------------------------------------#
	# Print the parameter file
	#------------------------------------------------------------------------------#

	# print the current parameter file
	echo -e "\n\t---- Printing the Parameter File ----\n"
	cat ${whole_parfile_name} | sed -e 's/^/\t\t/g'

	#------------------------------------------------------------------------------#
	# Run renumf90
	#------------------------------------------------------------------------------#

	# line to say initializing renumf90
	printf "\n\tInitializing renumf90 for %s \n\t-- Please wait...\n" $trait_names_together

		# run renumf90 on parameter file
		renumf90 <<< ${whole_parfile_name} > $basename.${trait_names_together}.renum.out
		printf "\t\tCompleted: $basename.${trait_names_together}.renum.out\n"

	#------------------------------------------------------------------------------#
	# Run application program 
	#------------------------------------------------------------------------------#

	# run the application program
	if [[ $program == airemlf90 ]]; then

		# line to say initializing airemlf90
		printf "\n\tInitializing airemlf90 for %s \n\t-- Please wait.......\n" $trait_names_together

		# Start airemlf90
		airemlf90 <<< renf90.par > $basename.${trait_names_together}.aireml.out
		printf "\t\tCompleted: $basename.${trait_names_together}.aireml.out\n"

		# Extract and print how many rounds it took to converge
		sed -n '/In round/p' $basename.${trait_names_together}.aireml.out | awk ' { print $3, $5 } ' > ${basename}.${trait_names_together}.conv

		if [ -e $gnuplot_script ]; then
			
			printf "\n\tWill use the provide gnuplot script\n"

		else 

			printf "\n\tDidn't find the gnuplot script. Will build my own\n"
		
			gnuplot_script=plot_conv.gnuplot
			echo "set term png" > plot_conv.gnuplot
			echo "set output \"my_output_file\"" >> plot_conv.gnuplot
			echo "plot 'my_input_file' with linespoints lc rgb 'red'" >> plot_conv.gnuplot
			echo "set title 'Convergence of (AI)REML'" >> plot_conv.gnuplot
			echo "set xlabel 'Round'" >> plot_conv.gnuplot
			echo "set ylabel 'Convergence'" >> plot_conv.gnuplot
			echo "unset key" >> plot_conv.gnuplot
			echo "quit" >> plot_conv.gnuplot
		
		fi

		# substitute file name
		sed 's/my_output_file/'"${basename}.${trait_names_together}.conv.png"'/g' $gnuplot_script > plot_conv2.gnuplot
		sed 's/my_input_file/'"${basename}.${trait_names_together}.conv"'/g' plot_conv2.gnuplot > plot_conv3.gnuplot

		# run gnuplot
		gnuplot plot_conv3.gnuplot

		# remove files
		rm -f plot_conv.gnuplot
		rm -f plot_conv2.gnuplot
		rm -f plot_conv3.gnuplot

		# print how many rounds
		NROUNDS=`sed -n '/In round/p' "$basename.${trait_names_together}.aireml.out" | awk 'BEGIN { max=0 }{if($3>max) max=$3} END { print max}'`
		printf "\n\t\t-- Rounds to converge:\t %s \n" $NROUNDS
		
		# Extract name of current renadd file
		current_renadd_file=`ls -t | grep -m 1 renadd*`

		# Rename aireml files
		if [[ $gs == 1 ]]; then

			# Move genomic files
			mv ${current_renadd_file}                           ./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.renadd 
			mv $basename.${trait_names_together}.renum.out 		./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.renum.out
			mv $basename.${trait_names_together}.aireml.out 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.${app_program_name}.out
			mv $basename.${trait_names_together}.conv 		 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.conv
			mv $basename.${trait_names_together}.conv.png 	 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.conv.png
			mv $whole_parfile_name                 				./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.par
			mv renf90.par                       				./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.renf90.par
			mv renf90.tables                    				./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.tables
			mv solutions 										./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.gs.sol

		else

			# Move non-genomic files
			mv ${current_renadd_file}                           ./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.renadd 
			mv $basename.${trait_names_together}.renum.out 		./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.renum.out
			mv $basename.${trait_names_together}.aireml.out 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.${app_program_name}.out
			mv $basename.${trait_names_together}.conv 		 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.conv
			mv $basename.${trait_names_together}.conv.png 	 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.conv.png
			mv $whole_parfile_name                 				./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.par
			mv renf90.par                      				 	./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.renf90.par
			mv renf90.tables                    				./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.tables
			mv solutions 										./${Output_Directory}/${trait_names_together}/$basename.${trait_names_together}.sol
		fi

	fi

	#------------------------------------------------------------------------------#
	# Get current time
	#------------------------------------------------------------------------------#

	# set start time
	time_after_analysis=`date +%s`  # in seconds

	#------------------------------------------------------------------------------#
	# Remove Files
	#------------------------------------------------------------------------------#

	# remove files
	rm -f subset.dat
	rm -f response_traits.txt
	rm -f current_response_traits.txt
	rm -f nonmissing_rows.txt
	rm -f nonmissing_rows_2.txt
	rm -f nonmissing_lines_uniq.txt
	
	#------------------------------------------------------------------------------#
	# Look at how long each chunk took
	#------------------------------------------------------------------------------#
	
	# set time differences
	time_diff_to_process=`echo "($time_after_process - $start_time)" | bc`
	time_diff_to_analyze=`echo "($time_after_analysis - $time_after_process) / 60" | bc`

	# print times
	printf "\n\tTime to complete processing parameter file (sec):\t\t%s\n" $time_diff_to_process
	printf "\tTime to complete analysis with application program (min):\t%s\n" $time_diff_to_analyze
	

# DONE with this parameter file
done # END of  beginning for loop through all parameter files

# remove extra files
rm -f parameter_files.txt
rm -f data_col_names.txt
rm -f data_file_columns.txt
rm -f ped_file_columns.txt
rm -f response_traits.txt

printf "\n\nParameter files found:\t%s" $n_par_files
printf "\nAnalyses completed:\t%s\n"    $(expr $ROUND - 1)

printf "\nDONE to HERE!\n"
exit 1







# this should be the end of the new script
# the next chunk is from the old script









#====================================================================================================#
# Set up Files
#====================================================================================================#

# start the loop to do all the 2 trait analyses
for (( i=$begin; i<=$end; i=i+1 )); do                  # i is the row
	for (( j=$begin; j<=$end; j=j+1 )); do              # j is the column

	# if i=j or i>j then skip the rest of the loop (only want to do the top half of the matrix, not both)
	# Only do the two trait analysis once (top half of matrix)	
	if [ $i -gt $j ]; then

		# If i is greater than j, skip this round (this would be the lower triangle)
		continue

	#------------------------------------------------------------------------------------------------#
	# One-trait Analyses
	#------------------------------------------------------------------------------------------------#

	# test if i = j (meaning it's the same trait, look for single trait file!)
	elif [ $i -eq $j ]; then

		# pull out the name of the trait for this round
		trait1=`awk ' NR=='""$i""' { print $1 } ' $HeaderFile `

		# set starting values from header file
		e_var_1=`awk ' NR=='""$i""' { print $2 } ' $HeaderFile `
		a_var_1=`awk ' NR=='""$i""' { print $3 } ' $HeaderFile `

		# Check for the parameter file needed for this single trait analysis
		if [[ ! -e $ParFile_Directory/"$basename"."$trait1".par ]]; then

			# Continue (skip round)
			continue

		fi

		# Specify what round it's in
		printf "\n\t#==============================================================================#\n"
		printf "\tRound:\t%s\n" $ROUND
		printf "\t#==============================================================================#\n"

		# Increase the round by 1 for the next round
		ROUND=$(( ROUND + 1 ))
		
		# Print that it's a single-trait analysis this round
		printf "\n\tSingle Trait Analysis\n"

		# Rename variables based on the header file		
		#trait1=`sed -n ''"$i"'p' $HeaderFile`
		printf "\n\tTrait is: %s\n" $trait1
		printf "\tStarting values for e and a are: %s and %s\n" $e_var_1 $a_var_1

		# Look for the basic parameter file given if no individual one exists
		if [[ ! -e $ParFile_Directory/"$basename"."$trait1".par ]] && [[ ! -z $ParFile ]] && [[ -e $ParFile_Directory/$ParFile ]]; then

			cp $ParFile_Directory/$ParFile $basename.$trait1.par

		fi

		# Check for the parameter file needed for this single trait analysis
		if [[ ! -e $ParFile_Directory/"$basename"."$trait1".par ]]; then

			# Display error that the parameter file doesn't exist
			printf "\n\tWARNING: Parameter file could not be found.\n\tMake sure it's named correctly.\n\tThis round will be skipped\n"
			
			# If the parameter file is not found, it will simply skip to the next trait and do those
			continue

		else

			# Print message that the parameter file has been found
			printf "\n\tThe parameter file is:\t %s\n" $basename.$trait1.par

		fi

		# Check the parameter file missing value
		missing_check=`sed -n '/missing '"$missing"'/p' $ParFile_Directory/$basename.$trait1.par` 

		# Check the missing values in the parameter files
		if [[ -z "$missing_check" ]]; then

			# Display error if missing value was not specified correctly
			printf "\n\tERROR: Need to set missing value to %s in parameter file!\n\n" $missing  >&2
			exit 1

		else 

			# Print the missing value was correctly specified
			printf "\n\tThe missing value is correctly specified in the parameter file\n"

		fi 

		# Make output directory
		if [ ! -d $trait1 ]; then

			# Create the output directory for the trait
			printf "\n\tCreating the output directory for trait:\t %s\n" $trait1

			# Make the directory for the 1 trait analysis
			mkdir $trait1

		fi

		# edit data for each trait (need to remove all records with both values missing)
		awk '!($'"$i"' == '"$missing"' ) { print }' $DataFile > subset.data

		# Print the number of records in the subset dataset (any with a missing response)
		n_records_dataset=`awk ' END { print NR } ' subset.data`
		printf "\n\tThe number of records in the dataset:\t %s\n" $n_records_dataset

		# replace the old data set for the new one in the parameter file
		# put "file.dat" below DataFile	keyword
		sed 's/file.dat/subset.data/g' $ParFile_Directory/$basename.$trait1.par > $basename.1.$trait1.par

		# replace values in general parameter file with the traits i and j
		# Put "trait1" below TRAITS keyword
		sed 's/trait1/'"$i"'/g' $basename.1.$trait1.par > $basename.2.$trait1.par 

		# search and replace starting values
		sed 's/e_var_1/'"$e_var_1"'/g' $basename.2.$trait1.par > $basename.3.$trait1.par
		sed 's/a_var_1/'"$a_var_1"'/g' $basename.3.$trait1.par > $basename.2.$trait1.par

		# remove parameter file
		rm -f $basename.3.$trait1.par

		# line to say initializing renumf90
		printf "\n\tInitializing renumf90 for %s \n\t-- Please wait.......\n" $trait1

		# run renumf90 on parameter file
		renumf90 <<< $basename.2.$trait1.par > $basename.$trait1.renum.out
		printf "\n\t$basename.$trait1.renum.out is Done\n"

		# run the application program
		if [[ $program == airemlf90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing airemlf90 for %s \n\t-- Please wait.......\n" $trait1

			# Start airemlf90
			airemlf90 <<< renf90.par > $basename.$trait1.aireml.out
			printf "\n\t$basename.$trait1.aireml.out is Done\n"

			# Extract and print how many rounds it took to converge
			NROUNDS=`sed -n '/In round/p' "$basename.$trait1.aireml.out" | awk 'BEGIN { max=0 }{if($3>max) max=$3} END { print max}'`
			printf "\n\t\t-- Rounds to converge:\t %s \n" $NROUNDS

			# Rename aireml files
			if [[ $gs == 1 ]]; then

				# Move genomic files
				mv $basename.$trait1.aireml.out 	$trait1/$basename.$trait1.gs.aireml.out
				mv solutions 						$trait1/$basename.$trait1.gs.sol
				mv renf90.par                       $trait1/$basename.$trait1.gs.renf90.par
				mv renf90.tables                    $trait1/$basename.$trait1.gs.tables

			else

				# Move non-genomic files
				mv $basename.$trait1.aireml.out 	$trait1/$basename.$trait1.aireml.out
				mv solutions 						$trait1/$basename.$trait1.sol
				mv renf90.par                       $trait1/$basename.$trait1.renf90.par
				mv renf90.tables                    $trait1/$basename.$trait1.tables
			fi

		elif [[ $program == remlf90 ]];then

			# line to say initializing remlf90
			printf "\n\tInitializing remlf90 for %s \n\t-- Please wait.......\n" $trait1

			# Start remlf90
			remlf90 <<< renf90.par > $basename.$trait1.reml.out
			printf "\n\t$basename.$trait1.reml.out is Done\n"

			# Extract and print how many rounds it took to converge
			NROUNDS=`sed -n '/In round/p' "$basename.$trait1.reml.out" | awk 'BEGIN { max=0 }{if($3>max) max=$3} END { print max}'`
			printf "\n\t\t-- Rounds to converge:\t %s \n" $NROUNDS

			# Rename reml files
			if [[ $gs == 1 ]]; then

				# Move genomic files
				mv $basename.$trait1.reml.out 	$trait1/$basename.$trait1.gs.reml.out
				mv solutions 					$trait1/$basename.$trait1.gs.sol
				mv renf90.par                   $trait1/$basename.$trait1.gs.renf90.par
				mv renf90.tables                $trait1/$basename.$trait1.gs.tables

			else

				# Move non-genomic files
				mv $basename.$trait1.reml.out 	$trait1/$basename.$trait1.reml.out
				mv solutions 					$trait1/$basename.$trait1.sol
				mv renf90.par                   $trait1/$basename.$trait1.renf90.par
				mv renf90.tables                $trait1/$basename.$trait1.tables

			fi


		elif [[ $program == gibbs2f90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing gibbs2f90 for %s \n\t-- Please wait.......\n" $trait1

			gibbs2f90 <<EOF > $basename.$trait1.gibbs_samples
renf90.par
$n_samples $burnin
$store
EOF
# number of samples + burn-in; store every ___ samples

			postgibbsf90 <<EOF > $basename.$trait1.postgibbs.out
renf90.par
0
$store
0
EOF
# number of samples + burn-in; store every ___ samples
# burn-in; read every ___; exit

			# Move files to trait directory
			mv $basename.$trait1.postgibbs.out	$trait1
			mv $basename.$trait1.gibbs_samples	$trait1
			mv gibbs_samples					$trait1
			mv postgibbs_samples				$trait1
			mv post*							$trait1
			mv renf90.par						$trait1
			mv renf90.tables					$trait1

		elif [[ $program == thrgibbs1f90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing thrgibbs1f90 for %s \n\t-- Please wait.......\n" $trait1

			thrgibbs1f90 <<EOF > $basename.$trait1.gibbs_samples
renf90.par
$n_samples $burnin
$store
EOF
# number of samples + burn-in; store every ___ samples

			postgibbsf90 <<EOF > $basename.$trait1.postgibbs.out
renf90.par
0
$store
0
EOF
# number of samples + burn-in; store every ___ samples
# burn-in; read every ___; exit

			# Move files to trait directory
			mv $basename.$trait1.postgibbs.out	$trait1
			mv $basename.$trait1.gibbs_samples	$trait1
			mv gibbs_samples					$trait1
			mv postgibbs_samples				$trait1
			mv post*							$trait1
			mv renf90.par						$trait1
			mv renf90.tables					$trait1

		else

			# Print error that the application program is not recognized
			printf "\n\tERROR: Application program not recognized\n\n" >&2
			exit 1

		fi

		# remove the subset dataset and parameter files
		printf "\n\tRemoving the temporary dataset and parameter file\n"
		rm -f subset.data
		rm -f $basename.1.$trait1.par

		# Check for output directory, create it if it does not exist
		if [ ! -d $Output_Directory ]; then

			# Create the output directory for the trait
			printf "\n\tCreating the output directory for trait:\t %s\n" $trait1

			# Make the output directory
			mkdir $Output_Directory

		fi

		# calculate genomic accuracies (need to run preGS prior to get GimA22i_ren.txt)
		# with "OPTION saveGimA22iRen" 
		if [[ $acc == 1 ]] && [[ $gs == 1 ]]; then

			# calculate approxmiated accuracies with genomics
			printf "\n\tCalculating approximated accuracies...\n"
			echo renf90.par | accf90GS > $basename.$trait1.gs.acc.out
			mv sol_and_acc $basename.$trait1.gs.acc.sol

		fi

		# calculate pedigree accuracies
		if [[ $acc == 1 ]] && [[ $gs == 0 ]]; then

			# calculate approxmiated accuracies without genomics
			printf "\n\tCalculating approximated accuracies...\n"
			echo renf90.par | accf90 > $basename.$trait1.acc.out
			mv sol_and_acc $basename.$trait1.acc.sol

		fi

		# rename the files to correspond with the correct trait
		if [[ $gs == 1 ]]; then

			# Move genomic files
			mv $basename.2.$trait1.par			$trait1/$basename.$trait1.gs.par
			mv $basename.$trait1.renum.out	 	$trait1/$basename.$trait1.gs.renum.out
			mv renf90.par						$trait1/$basename.$trait1.gs.renf90.par
			mv renf90.tables					$trait1/$basename.$trait1.gs.tables
			mv renadd* 							$trait1/$basename.$trait1.gs.renadd.out
			
			if [[ -e samples_covfuncs ]]; then

				# move samples from covariance function sampling
				mv samples_covfuncs				$trait1/$basename.$trait1.samples_covfuncs

			fi

		else

			# Move regular files
			mv $basename.2.$trait1.par			$trait1/$basename.$trait1.par
			mv $basename.$trait1.renum.out 		$trait1/$basename.$trait1.renum.out
			mv renf90.par						$trait1/$basename.$trait1.renf90.par
			mv renf90.tables					$trait1/$basename.$trait1.tables
			mv renadd*							$trait1/$basename.$trait1.renadd.out
			
			if [[ -e samples_covfuncs ]]; then

				# move samples from covariance function sampling
				mv samples_covfuncs				$trait1/$basename.$trait1.samples_covfuncs

			fi

		fi

		# Move Trait folder to output directory
		if [[ -d $Output_Directory/$trait1 ]]; then

			# Print error if the trait folder already exists within the output folder (won't exit though)
			printf "\n\tWARNING: The output directory already exists in the destination folder, cannot be moved\n"

		else 

			# Move trait folder to the output folder
			printf "\n\tTrait folder will be moved to the output folder\n"
			mv $trait1 $Output_Directory

		fi


# NOTE: textbelt is no longer FREE!!! So I had to delete this section...

		# Text that the analysis is complete for this round
#		if [ ! -z $cell ]; then
#
#			# Text me that it is done
#			curl http://textbelt.com/text -d number=$cell -d "message=Analysis for $trait1 is complete"
#
#		fi

		# reset the trait variable so it doesn't interfer with other analyses
		trait1=










	#------------------------------------------------------------------------------------------------#
	# Two-trait Analyses
	#------------------------------------------------------------------------------------------------#

	else

		# I added this check first so it didn't print out a hundred of those Round headers
		# This is so you can actually check your output file (you can use 'tee' in Linux)

		# set trait 1 and 2
		trait1=`awk ' NR=='""$i""' { print $1 } ' $HeaderFile `
		trait2=`awk ' NR=='""$j""' { print $1 } ' $HeaderFile `

		# get starting values for trait 1
		e_var_1=`awk ' NR=='""$i""' { print $2 } ' $HeaderFile `
		a_var_1=`awk ' NR=='""$i""' { print $3 } ' $HeaderFile `

		# get starting values for trait 2
		e_var_2=`awk ' NR=='""$j""' { print $2 } ' $HeaderFile `
		a_var_2=`awk ' NR=='""$j""' { print $3 } ' $HeaderFile `

		# Check for the parameter file needed for this two trait analysis
		if [[ ! -e $ParFile_Directory/"$basename"."$trait1"."$trait2".par ]]; then

			# skip round if not found
			continue

		fi

		# Specify what round it's in
		printf "\n\t#==============================================================================#\n"
		printf "\tRound:\t%s\n" $ROUND
		printf "\t#==============================================================================#\n"

		# Increase the round by 1 for the next round
		ROUND=$(( ROUND + 1 ))
			
		# Print that it's a two-trait analysis this round
		printf "\n\tTwo Trait Analysis\n"

		# Rename variables based on the header file, this grabs the name from the header file
		printf "\n\tTrait 1 is %s\n" $trait1
		printf "\tTrait 2 is %s\n" $trait2

		# print starting values
		printf "\n\tStarting values for trait 1, e and a are: %s and %s\n" $e_var_1 $a_var_1
		printf "\tStarting values for trait 2, e and a are: %s and %s\n" $e_var_2 $a_var_2

		# Look for the basic parameter file given if no individual one exists
		if [[ ! -e $ParFile_Directory/"$basename"."$trait1"."$trait2".par ]] && [[ ! -z $ParFile ]] && [[ -e $ParFile_Directory/$ParFile ]]; then

			cp $ParFile_Directory/$ParFile $basename.$trait1.$trait2.par

		fi

		# Check for the parameter file needed for this two trait analysis
		if [[ ! -e $ParFile_Directory/"$basename"."$trait1"."$trait2".par ]]; then

			# Display error that the parameter file doesn't exist
			printf "\n\tWARNING: Parameter file could not be found.\n\tMake sure it's named correctly.\n\tThis round will be skipped\n"
			
			# If the parameter file is not found, it will simply skip to the next trait and do those
			continue

		else

			# Print message that the parameter file has been found
			printf "\n\tThe parameter file is:\t %s\n" $basename.$trait1.$trait2.par

		fi
		

		# Check the parameter file missing value
		missing_check=`sed -n '/missing '"$missing"'/p' $ParFile_Directory/$basename.$trait1.$trait2.par` 

		# Check the missing values in the parameter files
		if [[ -z "$missing_check" ]]; then

			# Display error if missing value was not specified correctly
			printf "\n\tERROR: Need to set missing value to %s in parameter file!\n\n" $missing  >&2
			exit 1

		else 

			# Print the missing value was correctly specified
			printf "\n\tThe missing value is correctly specified in the parameter file\n"

		fi 

		# Check for the output directory, create it if it doesn't not exist
		if [ ! -d $trait1.$trait2 ]; then

			# Create the output directory for the trait
			printf "\n\tCreating the output directory for traits:\t %s and %s\n" $trait1 $trait2

			# Make the directory for the 2 trait analysis
			mkdir $trait1.$trait2

		fi

		# Edit data for each trait (need to remove all records with both values missing)
		if [[ $program == airemlf90 ]]; then

			# airemlf90 can handle missing values in only one of the two response variables
			awk ' !($'"$i"' == '"$missing"' && $'"$j"' == '"$missing"') { print } ' $DataFile > subset.data

		elif [[ $program == remlf90 ]]; then

			# remlf90 can handle missing values in only one of the two response variables
			awk ' !($'"$i"' == '"$missing"' && $'"$j"' == '"$missing"') { print } ' $DataFile > subset.data

		elif [[ $program == gibbs2f90 ]]; then

			# remlf90 can handle missing values in only one of the two response variables
			awk ' !($'"$i"' == '"$missing"' && $'"$j"' == '"$missing"') { print } ' $DataFile > subset.data

			# gibbs2f90 CANNOT handle missing values in either of the two response variables
			# awk ' !($'"$i"' == '"$missing"' || $'"$j"' == '"$missing"') { print } ' $DataFile > subset.data

		elif [[ $program == thrgibbs1f90 ]]; then

			# thrgibbs1f90 CANNOT handle missing values in either of the two response variables
			awk ' !($'"$i"' == '"$missing"' || $'"$j"' == '"$missing"') { print } ' $DataFile > subset.data

		else

			printf "\n\tERROR: program was not recognized\n\n" &>2
			exit 1

		fi

		# Print the number of records in the subset dataset
		n_records_dataset=`awk ' END { print NR } ' subset.data`
		printf "\n\tThe number of records in the dataset:\t %s\n" $n_records_dataset

		# Print the number of records with both not missing
		# n_complete_records=`awk '($'"$i"' != '"$missing"' && $'"$j"' != '"$missing"') END { print NR }' subset.data`
		# printf "\n\tThe number of complete records (both non-missing):\t %s\n" $n_complete_records

		# Replace the old data set for the new one in the parameter file
		# Put "file.dat" below DataFile keyword
		sed 's/file.dat/subset.data/g' $ParFile_Directory/$basename.$trait1.$trait2.par > $basename.1.$trait1.$trait2.par

		# Replace values in general parameter file with the traits i and j
		# Put "trait1 trait2" below TRAITS keyword
		sed 's/trait1 trait2/'"$i"' '"$j"'/g' $basename.1.$trait1.$trait2.par > $basename.2.$trait1.$trait2.par

		# search and replace starting values
		sed 's/e_var_1/'"$e_var_1"'/g' $basename.2.$trait1.$trait2.par > $basename.3.$trait1.$trait2.par
		sed 's/a_var_1/'"$a_var_1"'/g' $basename.3.$trait1.$trait2.par > $basename.2.$trait1.$trait2.par
		sed 's/e_var_2/'"$e_var_2"'/g' $basename.2.$trait1.$trait2.par > $basename.3.$trait1.$trait2.par
		sed 's/a_var_2/'"$a_var_2"'/g' $basename.3.$trait1.$trait2.par > $basename.2.$trait1.$trait2.par

		# remove the one with '3'
		rm -f $basename.3.$trait1.$trait2.par

		# line to say initializing renumf90
		printf "\n\tInitializing renumf90 for %s and %s \n\t-- Please wait.......\n" $trait1 $trait2

		# run renumf90 on parameter file
		renumf90 <<< $basename.2.$trait1.$trait2.par > $basename.$trait1.$trait2.renum.out
		printf "\n\t$basename.$trait1.$trait2.renum.out is Done\n"

		# run the application program
		if [[ $program == airemlf90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing airemlf90 for %s and %s \n\t-- Please wait.......\n" $trait1 $trait2

			# Begin aireml
			airemlf90 <<< renf90.par > $basename.$trait1.$trait2.aireml.out
			printf "\n\t$basename.$trait1.$trait2.aireml.out is Done\n"

			# Extract and print how many rounds it took to converge
			NROUNDS=`sed -n '/In round/p' "$basename.$trait1.$trait2.aireml.out" | awk 'BEGIN { max=0 }{if($3>max) max=$3} END { print max}'`
			printf "\n\t\t-- Rounds to converge:\t %s \n" $NROUNDS

			# Move aireml files
			if [[ $gs == 1 ]]; then

				# Move genomic files
				mv $basename.$trait1.$trait2.aireml.out 	$trait1.$trait2/$basename.$trait1.$trait2.gs.aireml.out
				mv solutions 								$trait1.$trait2/$basename.$trait1.$trait2.gs.sol
				mv renf90.par 								$trait1.$trait2/$basename.$trait1.$trait2.gs.renf90.par
				mv renf90.tables							$trait1.$trait2/$basename.$trait1.$trait2.gs.tables

			else

				# Move non-genomic files
				mv $basename.$trait1.$trait2.aireml.out 	$trait1.$trait2/$basename.$trait1.$trait2.aireml.out
				mv solutions 								$trait1.$trait2/$basename.$trait1.$trait2.sol
				mv renf90.par 								$trait1.$trait2/$basename.$trait1.$trait2.renf90.par
				mv renf90.tables							$trait1.$trait2/$basename.$trait1.$trait2.tables

			fi

		elif [[ $program == remlf90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing remlf90 for %s and %s \n\t-- Please wait.......\n" $trait1 $trait2

			# Begin reml
			remlf90 <<< renf90.par > $basename.$trait1.$trait2.reml.out
			printf "\n\t$basename.$trait1.$trait2.reml.out is Done\n"

			# Extract and print how many rounds it took to converge
			NROUNDS=`sed -n '/In round/p' "$basename.$trait1.$trait2.reml.out" | awk 'BEGIN { max=0 }{if($3>max) max=$3} END { print max}'`
			printf "\n\t\t-- Rounds to converge:\t %s \n" $NROUNDS

			# Move reml files
			if [[ $gs == 1 ]]; then

				# Move genomic files
				mv $basename.$trait1.$trait2.reml.out 	$trait1.$trait2/$basename.$trait1.$trait2.gs.reml.out
				mv solutions 							$trait1.$trait2/$basename.$trait1.$trait2.gs.sol
				mv renf90.par 							$trait1.$trait2/$basename.$trait1.$trait2.gs.renf90.par
				mv renf90.tables						$trait1.$trait2/$basename.$trait1.$trait2.gs.tables
	
				if [[ -e samples_covfuncs ]]; then

					# move samples from covariance function sampling
					mv samples_covfuncs				$trait1/$basename.$trait1.samples_covfuncs

				fi

			else

				# Move non-genomic files
				mv $basename.$trait1.$trait2.reml.out 	$trait1.$trait2/$basename.$trait1.$trait2.reml.out
				mv solutions 							$trait1.$trait2/$basename.$trait1.$trait2.sol
				mv renf90.par 							$trait1.$trait2/$basename.$trait1.$trait2.renf90.par
				mv renf90.tables						$trait1.$trait2/$basename.$trait1.$trait2.tables
	
				if [[ -e samples_covfuncs ]]; then

					# move samples from covariance function sampling
					mv samples_covfuncs				$trait1/$basename.$trait1.samples_covfuncs

				fi
			fi

		elif [[ $program == gibbs2f90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing gibbs2f90 for %s and %s\n\t-- Please wait.......\n" $trait1 $trait2

			gibbs2f90 <<EOF > $basename.$trait1.$trait2.gibbs_samples
renf90.par
$n_samples $burnin
$store
EOF
# number of samples + burn-in; store every ___ samples

			postgibbsf90 <<EOF > $basename.$trait1.$trait2.postgibbs.out
renf90.par
0
$store
0
EOF
# burn-in; read every ___; exit

			# Move files to trait directory
			mv $basename.$trait1.$trait2.postgibbs.out	$trait1.$trait2
			mv $basename.$trait1.$trait2.gibbs_samples	$trait1.$trait2
			mv gibbs_samples							$trait1.$trait2
			mv postgibbs_samples						$trait1.$trait2
			mv post*									$trait1.$trait2
			mv renf90.par								$trait1.$trait2
			mv renf90.tables							$trait1.$trait2

		elif [[ $program == thrgibbs1f90 ]]; then

			# line to say initializing airemlf90
			printf "\n\tInitializing thrgibbs1f90 for %s and %s\n\t-- Please wait.......\n" $trait1 $trait2

			thrgibbs1f90 <<EOF > $basename.$trait1.$trait2.gibbs_samples
renf90.par
$n_samples $burnin
$store
EOF
# number of samples + burn-in; store every ___ samples

			postgibbsf90 <<EOF > $basename.$trait1.$trait2.postgibbs.out
renf90.par
0
$store
0
EOF
# burn-in; read every ___; exit

			# Move files to trait directory
			mv $basename.$trait1.$trait2.postgibbs.out	$trait1.$trait2
			mv $basename.$trait1.$trait2.gibbs_samples	$trait1.$trait2
			mv gibbs_samples							$trait1.$trait2
			mv postgibbs_samples						$trait1.$trait2
			mv post*									$trait1.$trait2
			mv renf90.par								$trait1.$trait2
			mv renf90.tables							$trait1.$trait2

		else

			# Print error that the application program is not recognized
			printf "\n\tERROR: Application program not recognized\n\n" >&2
			exit 1

		fi

		# remove the subset dataset and parameter files
		printf "\n\tRemoving the temporary dataset and parameter file\n"
		rm -f subset.data
		rm -f $basename.1.$trait1.$trait2.par
		
		# calculate genomic accuracies (need to run preGS prior to get GimA22i_ren.txt)
		# with "OPTION saveGimA22iRen" 
		if [[ $acc == 1 ]] && [[ $gs == 1 ]]; then

			# calculate the approximated accuracies with genomics
			printf "\n\tCalculating approximated accuracies...\n"
			echo renf90.par | accf90GS > $basename.$trait1.$trait2.gs.acc.out
			mv sol_and_acc $basename.$trait1.$trait2.gs.acc.sol

		fi
		
		# calculate pedigree accuracies
		if [[ $acc == 1 ]] && [[ $gs == 0 ]]; then

			# calculate the approximated accuracies without genomics
			printf "\n\tCalculating approximated accuracies...\n"
			echo renf90.par | accf90 > $basename.$trait1.$trait2.acc.out
			mv sol_and_acc $basename.$trait1.$trait2.acc.sol

		fi


		# rename the files to correspond with the correct trait
		if [[ $gs == 1 ]]; then

			# Rename the genomic files
			mv $basename.2.$trait1.$trait2.par			$trait1.$trait2/$basename.$trait1.$trait2.gs.par
			mv $basename.$trait1.$trait2.renum.out		$trait1.$trait2/$basename.$trait1.$trait2.gs.renum.out
			mv renf90.par								$trait1.$trait2/$basename.$trait1.$trait2.gs.renf90.par
			mv renadd* 									$trait1.$trait2/$basename.$trait1.$trait2.gs.renadd.out

		else

			# Rename regular files
			mv $basename.2.$trait1.$trait2.par			$trait1.$trait2/$basename.$trait1.$trait2.par
			mv $basename.$trait1.$trait2.renum.out		$trait1.$trait2/$basename.$trait1.$trait2.renum.out
			mv renf90.par								$trait1.$trait2/$basename.$trait1.$trait2.renf90.par
			mv renadd* 									$trait1.$trait2/$basename.$trait1.$trait2.renadd.out

		fi

		# Move Trait folder to output directory
		if [[ -d $Output_Directory/$trait1.$trait2 ]]; then

			# Print error if the trait folder already exists within the output folder (won't exit though)
			printf "\n\tWARNING: The output directory already exists in the destination folder, cannot be moved\n"

		else 

			# Move trait folder to the output folder
			printf "\n\tTrait folder will be moved to the output folder\n"
			mv $trait1.$trait2 $Output_Directory

		fi

		# Text that the analysis is complete for this round
		if [ ! -z $cell ]; then

			# Text me when it is done
			curl http://textbelt.com/text -d number=$cell -d "message=Analysis for $trait1 and $trait2 is complete"

		fi

		# reset the trait variable so it doesn't interfer with other analyses
		trait1=
		trait2=

	fi

	done
done

echo -e "\nANALYSIS DONE!\n"






