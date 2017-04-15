#!/bin/bash

#====================================================================================================#
# tt : Two Trait Analysis
#====================================================================================================#

# tt : This script is made to cycle through all combinations of 2 traits
# and run remumf90 and the specified application program (with output files for both)

# This script will take a general parameter file and copy it if individual parameter files
# don't exist for each trait combination

# Change into the currect working directory
cd .

#====================================================================================================#
# Options
#====================================================================================================#

# Options you can specify
# 	-a		= application program
# 	-s		= start of columns
# 	-e		= end of columns
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
# Set Options
#====================================================================================================#

# set defaults
acc=0
gs=0

# loop through all positional variables to set variables
if [ -z $1 ]; then        # check to see if any options are even given

	# Print usage if nothing is specified
	printf "\n\tUsage:\n" 1>&2
	printf "\t-a     = application program (remlf90, airemlf90, thrgibbs1f90)\n" 1>&2
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
	printf "\t-st    = store every __ samples\n\n" 1>&2

 	exit 1

else
 	while [[ $# -gt 0 ]]; do 
 		case $1 in

		# set all the variable values
			-a)     shift
					program=$1				# application program to be used
					;;
 			-s)		shift
 					begin=$1				# sets where the columns begin
 					;;
 			-e) 	shift
 					end=$1					# sets where the columns end
 					;;
			-p)		shift
					PARFILE=$1				# sets the generalized parameter file
 					;;
			-pd)	shift
					parfile_directory=$1    # parameter file directory
					;;
 			-d)		shift
 					DATAFILE=$1				# sets the overall data set
 					;;	
			-h) 	shift
					HEADERFILE=$1			# specifies column names all on a separate line!
					;;
			-b)     shift
					basename=$1				# used to be filenamebase --> basename
					;;
			-m) 	shift
					missing=$1				# set missing value
					;;
			-o)		shift
					output_directory=$1		# Output directory
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
					store=$1				# store every ___ amples
					;;
 			*)		printf "\n\tInvalid option, try again\n\n" >&2  # any options not recognized will get an error message
 					exit 1
 					;;
 		esac
 		shift
	done
fi

# The following is code to check all the options that the user will input

#====================================================================================================#
# Application program
#====================================================================================================#

printf "\nAPPLICATION PROGRAM\n"

if [[ $program == airemlf90 ]] || [[ $program == remlf90 ]] || [[ $program == thrgibbs1f90 ]]; then

	# Print the name of the program
	printf "\n\tApplication program used will be:\t %s\n" $program

else

	# Display error if not one of the programs
	printf "\n\tERROR: Application program not found\n\tTakes \"aireml\", \"reml\", and \"thrgibbs1f90\"\n\n" >&2
	exit 1

fi


if [[ $program == thrgibbs1f90 ]]; then

	printf "\n\tthrgibbs checks\n"

	if [[ ! -z $n_samples ]] && [[ ! -z $burnin ]] && [[ ! -z $store ]]; then

		printf "\n\t\tAll the options for thrgibbs1f90 have been specified\n"

	else

		printf "\n\t\tERROR: One of the options needed for thrgibbs was forgotten\n" >&2
		exit 1

	fi

	printf "\n\t\tThe number of samples:\t%s" $n_samples
	printf "\n\t\tThe burnin was:\t\t%s" $burnin
	printf "\n\t\tStore every:\t\t%s" $store

	if [ $n_samples -gt 1 ] && [ $n_samples -lt 10000000 ]; then

		printf "\n\t\tThe number of samples is acceptable\n"

	else

		printf "\n\t\tThe number of samples is out of bounds\n" >&2
		exit 1

	fi

	if [ $burnin -gt -1 ] && [ $burnin -lt 1000000 ]; then

		printf "\n\t\tThe burn-in is acceptable\n"
	
	else

		printf "\n\t\tThe burn-in is out of bounds\n" >&2
		exit 1

	fi

	if [ $store -gt 0 ] && [ $store -lt 10000 ]; then

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
if [ -z $parfile_directory ]; then

	# Display error if nothing is specified for the parameter file directory
	printf "\n\tERROR: No parameter file directory specified\n" >&2
	exit 1

elif [ ! -d $parfile_directory ]; then

	# Display error if it's not actually a directory
	printf "\n\tERROR: The parameter file directory specified cannot be found\n" >&2
	exit 1

else

	# Print the parameter file directory
	printf "\n\tThe parameter file directory:\t %s\n" $parfile_directory

fi

#====================================================================================================#
# Parameter file
#====================================================================================================#

printf "\nPARAMETER FILE\n"

# Check if there is a parameter file given (REQUIRED)
if [ -z $PARFILE ]; then

  # error message if there is no parameter file specified
	printf "\n\tWARNING: No parameter file given so assuming each trait has an individual parameter file\n"

elif [ ! -e $parfile_directory/$PARFILE ]; then

  # error message if the parmeter file is not a real file
	printf "\n\tERROR: Parameter file specified is not a file\n\n" >&2
	exit 1
	
else

	# Print the name of the parameter file
	printf "\n\tThe parameter file being used is:\t %s\n" $PARFILE

fi

#====================================================================================================#
# Data file
#====================================================================================================#

printf "\nDATAFILE\n"

# Check if there is a data file given (REQUIRED)
if [ -z $DATAFILE ]; then

	# Sent to standard error if no data file is specified 
	printf "\n\tERROR: Need data file\n\n" >&2
	exit 1

elif [ ! -e $DATAFILE ]; then

	# Error message if the data file specified does not exist
	printf "\n\tERROR: Data file specified is not a file\n\n" >&2
	exit 1

else

	# print the data file
	printf "\n\tThe data file being used is:\t %s\n" $DATAFILE

fi

# check how many columns there are in the data file
n_dataset_columns=`awk ' END { print NF } ' $DATAFILE`
printf "\n\tColumns in the dataset: \t %s\n" $n_dataset_columns

#====================================================================================================#
# Header file
#====================================================================================================#

printf "\nHEADER\n" 

# check if there is a header file specified in options
if [ -z $HEADERFILE ]; then
	
	# Print error message for no header specified
	printf "\n\tERROR: No header file specified\n\n" >&2
	exit 1

else

	# Print the header file name
	printf "\n\tThe header file being used is:\t %s\n" $HEADERFILE

fi

# Get the number of rows in the header file
n_header_rows=`awk ' END { print NR } ' $HEADERFILE`

# Check to see if the number of rows in header file = number of fields in data file
if [ $n_dataset_columns -ne $n_header_rows ]; then

	# Display error message if the number of columns in the data 
	# and number of rows in the header file aren't equal
	printf "\n\tERROR: Number of columns in data frame not equal to number of lines in header file\n\n" >&2
	exit 1

fi

#====================================================================================================#
# Traits
#====================================================================================================#

printf "\nTRAITS\n"

# Check for starting and ending columns (REQUIRED)
if [ ! -z $begin ] && [ ! -z $end ]; then

	# Print starting and ending values
	printf "\n\tStarting and ending values have been given\n"

else

	# Display error if they are not given
	printf "\n\tERROR: Need starting and ending values\n\n" >&2
	exit 1

fi

# Check to see if they are within the range of the number of columns in the data file
if [ $begin -lt 1 ] || [ $begin -gt $n_dataset_columns ] || [ $end -lt 1 ] || [ $end -gt $n_dataset_columns ]; then

	# Display error if the starting and ending values are out of bounds
	printf "\n\tERROR: Columns are out of bounds (need to greater than 0 and less than %s)\n\n" $n_dataset_columns >&2
	exit 1

fi

# Check to make sure that starting column is less than the ending column
if [ $begin -ge $end ]; then

	# Display error if the starting value is larger than the ending value
	printf "\n\tERROR: Starting column is larger or equal to ending value!\n\n" >&2
	exit 1

fi

# echo what the starting and ending columns are
printf "\n\tThe starting column is:\t %s\n" $begin
printf "\n\tThe ending column is:\t %s\n" $end

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

if [ -z $output_directory ]; then

	# Display error message if missing
	printf "\n\tERROR: No output directory specified\n\n" >&2
	exit 1

elif [ -d $output_directory ]; then

	# Display warning message
	printf "\n\tWARNING: Output folder is already present and will not be overwritten\n"

else

	# Print output directory
	printf "\n\tThe output directory will be created:\t %s\n" $output_directory

	# Create the output_directory
	mkdir $output_directory

fi

#====================================================================================================#
# Number
#====================================================================================================#

printf "\nNUMBER\n"

if [ -z $cell ]; then

	# Print message saying NO cellphone number
	printf "\n\tNo cell phone number was given. No alert will be sent when analysis is done\n"

else

	# Print message saying what the cell number is
	printf "\n\tThe cell number given is:\t %s\n" $cell

fi

#====================================================================================================#
# END OF INPUT OPTION CHECKING
#====================================================================================================#





#====================================================================================================#
# This is the beginning of the actual loop to go through and run all the analyses
#====================================================================================================#

#====================================================================================================#
# Round 
#====================================================================================================#

# Set starting round at 1
ROUND=1

#====================================================================================================#
# Loop
#====================================================================================================#

printf "\nSTARTING ANALYSIS...\n"

# start the loop to do all the 2 trait analyses
for (( i=$begin; i<=$end; i=i+1 )); do                  # i is the row
	for (( j=$begin; j<=$end; j=j+1 )); do              # j is the column

	# if i=j or i>j then skip the rest of the loop
	# only do the two trait analysis once (top half of matrix)	
	if [ $i -gt $j ]; then

		# If i is greater than j, skip this round (this would be the lower triangle)
		continue

	#------------------------------------------------------------------------------------------------#
	# One-trait Analyses
	#------------------------------------------------------------------------------------------------#

	elif [ $i -eq $j ]; then

		# Specify what round it's in
		printf "\n\t#==============================================================================#\n"
		printf "\tRound:\t%s\n" $ROUND
		printf "\t#==============================================================================#\n"

		# Increase the round by 1 for the next round
		ROUND=$(( ROUND + 1 ))
		
		# Print that it's a single-trait analysis this round
		printf "\n\tSingle Trait Analysis\n"

		# Rename variables based on the header file		
		trait1=`sed -n ''"$i"'p' $HEADERFILE`
		printf "\n\tTrait is: %s\n" $trait1

		# Look for the basic parameter file given if no individual one exists
		if [[ ! -e $parfile_directory/"$basename"."$trait1".par ]] && [[ ! -z $PARFILE ]] && [[ -e $parfile_directory/$PARFILE ]]; then

			cp $parfile_directory/$PARFILE $basename.$trait1.par

		fi

		# Check for the parameter file needed for this single trait analysis
		if [[ ! -e $parfile_directory/"$basename"."$trait1".par ]]; then

			# Display error that the parameter file doesn't exist
			printf "\n\tWARNING: Parameter file could not be found.\n\tMake sure it's named correctly.\n\tThis round will be skipped\n"
			
			# If the parameter file is not found, it will simply skip to the next trait and do those
			continue

		else

			# Print message that the parameter file has been found
			printf "\n\tThe parameter file is:\t %s\n" $basename.$trait1.par

		fi

		# Check the parameter file missing value
		missing_check=`sed -n '/missing '"$missing"'/p' $parfile_directory/$basename.$trait1.par` 

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
		awk '!($'"$i"' == '"$missing"' ) { print }' $DATAFILE > subset.data

		# Print the number of records in the subset dataset (any with a missing response)
		n_records_dataset=`awk ' END { print NR } ' subset.data`
		printf "\n\tThe number of records in the dataset:\t %s\n" $n_records_dataset

		# replace the old data set for the new one in the parameter file
		# put "file.dat" below DATAFILE	keyword
		sed 's/file.dat/subset.data/g' $parfile_directory/$basename.$trait1.par > $basename.1.$trait1.par

		# replace values in general parameter file with the traits i and j
		# Put "trait1" below TRAITS keyword
		sed 's/trait1/'"$i"'/g' $basename.1.$trait1.par > $basename.2.$trait1.par 

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

			else

				# Move non-genomic files
				mv $basename.$trait1.aireml.out 	$trait1/$basename.$trait1.aireml.out
				mv solutions 						$trait1/$basename.$trait1.sol
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

			else

				# Move non-genomic files
				mv $basename.$trait1.reml.out 	$trait1/$basename.$trait1.reml.out
				mv solutions 					$trait1/$basename.$trait1.sol
			fi



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
		if [ ! -d $output_directory ]; then

			# Create the output directory for the trait
			printf "\n\tCreating the output directory for trait:\t %s\n" $trait1

			# Make the output directory
			mkdir $output_directory

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
			mv renadd* 							$trait1/$basename.$trait1.gs.renadd.out

		else

			# Move regular files
			mv $basename.2.$trait1.par			$trait1/$basename.$trait1.par
			mv $basename.$trait1.renum.out 		$trait1/$basename.$trait1.renum.out
			mv renf90.par						$trait1/$basename.$trait1.renf90.par
			mv renadd*							$trait1/$basename.$trait1.renadd.out

		fi

		# Move Trait folder to output directory
		if [[ -d $output_directory/$trait1 ]]; then

			# Print error if the trait folder already exists within the output folder (won't exit though)
			printf "\n\tWARNING: The output directory already exists in the destination folder, cannot be moved\n"

		else 

			# Move trait folder to the output folder
			printf "\n\tTrait folder will be moved to the output folder\n"
			mv $trait1 $output_directory

		fi

		# Text that the analysis is complete for this round
		if [ ! -z $cell ]; then

			# Text me that it is done
			curl http://textbelt.com/text -d number=$cell -d "message=Analysis for $trait1 is complete"

		fi

		# reset the trait variable so it doesn't interfer with other analyses
		trait1=

	#------------------------------------------------------------------------------------------------#
	# Two-trait Analyses
	#------------------------------------------------------------------------------------------------#

	else

		# Specify what round it's in
		printf "\n\t#==============================================================================#\n"
		printf "\tRound:\t%s\n" $ROUND
		printf "\t#==============================================================================#\n"

		# Increase the round by 1 for the next round
		ROUND=$(( ROUND + 1 ))
			
		# Print that it's a two-trait analysis this round
		printf "\n\tTwo Trait Analysis\n"

		# Rename variables based on the header file, this grabs the name from the header file
		trait1=`sed -n ''"$i"'p' $HEADERFILE`
		printf "\n\tTrait 1 is %s\n" $trait1
		trait2=`sed -n ''"$j"'p' $HEADERFILE`
		printf "\tTrait 2 is %s\n" $trait2

		# Look for the basic parameter file given if no individual one exists
		if [[ ! -e $parfile_directory/"$basename"."$trait1"."$trait2".par ]] && [[ ! -z $PARFILE ]] && [[ -e $parfile_directory/$PARFILE ]]; then

			cp $parfile_directory/$PARFILE $basename.$trait1.$trait2.par

		fi

		# Check for the parameter file needed for this two trait analysis
		if [[ ! -e $parfile_directory/"$basename"."$trait1"."$trait2".par ]]; then

			# Display error that the parameter file doesn't exist
			printf "\n\tWARNING: Parameter file could not be found.\n\tMake sure it's named correctly.\n\tThis round will be skipped\n"
			
			# If the parameter file is not found, it will simply skip to the next trait and do those
			continue

		else

			# Print message that the parameter file has been found
			printf "\n\tThe parameter file is:\t %s\n" $basename.$trait1.$trait2.par

		fi
		

		# Check the parameter file missing value
		missing_check=`sed -n '/missing '"$missing"'/p' $parfile_directory/$basename.$trait1.$trait2.par` 

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
			awk ' !($'"$i"' == '"$missing"' && $'"$j"' == '"$missing"') { print } ' $DATAFILE > subset.data

		elif [[ $program == remlf90 ]]; then

			# remlf90 can handle missing values in only one of the two response variables
			awk ' !($'"$i"' == '"$missing"' && $'"$j"' == '"$missing"') { print } ' $DATAFILE > subset.data


		elif [[ $program == thrgibbs1f90 ]]; then

			# thrgibbs1f90 CANNOT handle missing values in either of the two response variables
			awk ' !($'"$i"' == '"$missing"' || $'"$j"' == '"$missing"') { print } ' $DATAFILE > subset.data

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
		# Put "file.dat" below DATAFILE keyword
		sed 's/file.dat/subset.data/g' $parfile_directory/$basename.$trait1.$trait2.par > $basename.1.$trait1.$trait2.par

		# Replace values in general parameter file with the traits i and j
		# Put "trait1 trait2" below TRAITS keyword
		sed 's/trait1 trait2/'"$i"' '"$j"'/g' $basename.1.$trait1.$trait2.par > $basename.2.$trait1.$trait2.par

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

			else

				# Move non-genomic files
				mv $basename.$trait1.$trait2.aireml.out 	$trait1.$trait2/$basename.$trait1.$trait2.aireml.out
				mv solutions 								$trait1.$trait2/$basename.$trait1.$trait2.sol

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

			else

				# Move non-genomic files
				mv $basename.$trait1.$trait2.reml.out 	$trait1.$trait2/$basename.$trait1.$trait2.reml.out
				mv solutions 							$trait1.$trait2/$basename.$trait1.$trait2.sol

			fi

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
		if [[ -d $output_directory/$trait1.$trait2 ]]; then

			# Print error if the trait folder already exists within the output folder (won't exit though)
			printf "\n\tWARNING: The output directory already exists in the destination folder, cannot be moved\n"

		else 

			# Move trait folder to the output folder
			printf "\n\tTrait folder will be moved to the output folder\n"
			mv $trait1.$trait2 $output_directory

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

