# BLUPF90 Wrapper page

This will explain how to use the BLUPF90 wrapper I have written as a Linux bash script (Ubuntu). 

Please report bugs or other problems. 

# Getting Started

The easiest way to explain is to probable just show you an example. Here is a screenshot of the command line. 

![Screenshot of Script](/BLUPF90_Wrapper/Screenshots/blupf90_wrapper_sh.png?raw=true "bash script example")

You can the program and then other options. 

![Screenshot of Script](/BLUPF90_Wrapper/Screenshots/blupf90_sh_options.png?raw=true "bash script example")

This shows you what you will get with no input to `blupf90.v1.0.sh`. It will show you what options are available. 

# Overview

What this script does is loops from column x to x (10 to 15 lets say) and finds the parameter file to run. It processes the data for missing data which is very handy for many analyses. The gibbs samplers will stop with missing values for some odd reason. For multitrait models (2 trait so far) it will delete only those lines with both missing. Files that it doesn't find, it just skips and goes to the next analysis. It looks for column names in the `header.txt` file (or whatever you name it). You place the term `trait1 trait2` in the line following TRAITS in the parameter file and it replaces these with the correct column numbers. You add `file.dat` as the keyword to replace after the DATAFILE keyword in the parameter files. It replaces this with the processed datafile. 

# Inputs

1. application program = program you want it to use (remlf90, airemlf90, gibbs2f90, thrgibbs1f90)
2. starting column = first column where you have a response variable
3. last column = last column you have for a response
4. parameter file = in previous versions the model was the exact same so it just replaces the response columns
5. parametre file directory = directory to find parameter files with format basename.trait1.trait2.par
6. data file = data file (space delimited, no header, missing as specified by user) to subset without missing
7. basename = basename of files such as `project1`, name files `project1.ADG.ADFI.par`. The files need to be names in the order they appear in the dataset. So if ADG comes before ADFI it needs to be first. 
8. missing = missing value in the dataset
9 output = output directory to move files to
10 number = used to be free to send texts, now it's not so don't use this, will delete it
11. acc = to run accf90
12. gs = for genomic selection
13. ns = number of samples for gibbs sampler
14. bi = burn-in for gibbs sampler
15. st = store every ___ samples for gibbs sampler



