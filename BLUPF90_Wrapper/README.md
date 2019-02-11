# BLUPF90 Wrapper page

This will explain how to use the BLUPF90 wrapper I have written as a Linux bash script (Ubuntu). 
The idea is to loop through all your parameter files and run them one after another. 
You can set many of these runs to get all of your analyses done. 

Please report bugs or other problems, this script is not extensively tested. I developed
on Ubuntu 16.04, please do not run on a Mac because it's not the GNU version with the
'-i' option for sed to search and replace 'in place'. 

# Getting Started

The easiest way to explain is to probable just show you an example. Here is a screenshot of the command line. 

![Screenshot of Script](/BLUPF90_Wrapper/Screenshots/run_shell_script.png?raw=true "bash script example")

You can the program and then other options. 

![Screenshot of Script](/BLUPF90_Wrapper/Screenshots/blupf90_shell_script_message.png?raw=true "bash script example")

This shows you what you will get with no input to `blupf90.sh`. It will show you what options are available. 

# Overview

What this script does is loops through all the files within the parameter 
file directory (folder) and runs each analysis one-by-one. 
It processes the data for missing data which is very handy for many 
analyses. The gibbs samplers will stop with missing values for some odd 
reason. For multitrait models (2 trait so far) it will delete only those 
lines with both missing. Files that it doesn't find, it just skips and 
goes to the next analysis. It looks for column names in the `header.txt` 
file (or whatever you name it). You place the term `trait1 trait2` in the 
line following TRAITS in the parameter file and it replaces these with the 
correct column numbers. You add `file.dat` as the keyword to replace after 
the DATAFILE keyword in the parameter files. It replaces this with the processed datafile. 

# Inputs

1. Application program = program you want it to use (remlf90, airemlf90, gibbs2f90, thrgibbs1f90)
2. Parameter file directory = directory to find parameter files with format basename.trait1.trait2.par
3. Output file directory = directory to output individual analyses folders into
4. Data file = data file (space delimited, no header, missing as specified by user) to subset without missing
5. Pedigree file = pedigree file for analyses
6. Genotype file = genotype file for analyses
7. Map file = map file for analyses
8. Basename - first part of the paramter files (all the same) = basename of files such as `project1`, name files `project1.ADG.ADFI.par`. The files need to be names in the order they appear in the dataset. So if ADG comes before ADFI it needs to be first. 
9. Missing = missing value in the dataset
10. acc = to run accf90
11. gs = for genomic selection
12. ns = number of samples for gibbs sampler
13. bi = burn-in for gibbs sampler
14. st = store every x samples for gibbs sampler



