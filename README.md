# BLUPF90

Anything I do related to the BLUPF90 programs will be included in this repository. 





## What's included in this repository?



### 1 - vim syntax highlighting files

vim is the most common command line text editor for Mac OS X and Linux, although it can also exist on Windows computers. vim syntax highlighting files allow the user to see keywords highlighted in real time. This will hopefully eliminate one of the most common problems, which is spelling things wrong. For instance adding EFFETC in your parameter file instead of EFFECT. vim highlighting would display an error and it could be fixed immediately without ever running the parameter file. 

If you have problems after downloading use:
```bash
vim my_file.par
:set syntax=par
```

This will tell vim to find the file and use par as the syntax highlighting file. 

### 2 - man pages

Man pages are available on Mac OS X and Linux systems. I prefer them to the alternative info pages, which to me look like very poorly formated text files. Man pages are formatted much better and don't take you to a random page if that program doesn't exist. It's my hope that they will eventually have much more information than what their wiki currently has. I may just add documentation to this repository instead. 

I think I may move to GitHub for this as these are extensively used or kept up to date. I'm also having problems getting my systems to recognize them on Linux. 

Example:
![](/Screenshots/blupf90_man_page.png)

### 3 - blupf90.0.x.sh

This script was designed to loop through numerous parameter files and solve for variance components. I can get the documentation together if anyone is interested in using it. 

blupf90.sh is a bash script that is designed to make your life easy
when working with the blupf90 family of programs. It was 
developed in Ubuntu 14.04. Please let me know if there are
conflicts with other OS's (especially Linux as I assume most
are done on Linux servers, but Mac is common as well and
runs bash). Sorry Windows people out there. 
If you can write a comparable batch file that does the 
same thing I would love to see it. 

Ever have a situation where your boss gives you 10 traits to analyze
and you have to do all 2 trait combinations to get 
genetic correlations? Very common task in animal breeding,
yet the UGA programs (BLUPF90) don't have a wrapper around
their programs for anything like this (as far as I know).
The solution for me was to write a Linux script that loops
over all the trait combinations and does each analysis
one by one. This has saved me many hours of "by hand" work. 
My first solutions to this script were not very robust
and hard to use (many of them doing slightly different
tasks). This beta version allows high flexibility by
doing 1 and 2 trait analyses, aireml and thrgibbs1f90, 
and the ability to give a general parameter file so you
don't need to make individuals ones if they are all the 
same. 

Real documentation will follow. If you stumbled upon this
page and you are interested please email me and I can 
speed up the documentation process. If not I may not 
worry about it until someone does... If you are
good with bash scripts, you can probably figure out how 
it works by yourself by looking at my code.



### 4 - Examples

This is a folder with examples. I'm using QMSim to generate files for now, but I'd like to add all the examples from Mrode's book when I have time. 





## How do I download the BLUPF90 programs?

Go to this [link](http://nce.ads.uga.edu/html/projects/programs/) --> go to needed folder OS

You should now be in a directory with the names of the programs. 

Click on any of the programs to download (save) them directly to your computer. Make sure to make executable. 



### On Mac or Linux:

Go to the Downloads folder and convert them to an executable with:
```bash
  $ chmod 775 name_of_program
```

Once you have them as executable you can move them to your folder (directory) that you are working in and need to run the programs from. All you will need to do is add "./" in front of the name of the program. This tells your computer that the program is in the current working directory. 
```bash
  $ ./name_of_program
```

**Advanced!**

Make a `~/bin` directory if you don't have one already (default in Ubuntu)
```bash
  $ cd
  $ mkdir bin
```

Move these programs you downloaded to your `~/bin/` or `$HOME/bin` directory (these are one in the same):
```bash
  $ cd ~/Downloads
  $ mv name_of_program ~/bin
```

Repeat the move command as many times as needed (for each program). 

Follow this up by adding a line to your `.bash_profile` (this file is in your home directory where Documents, Pictures, Downloads, etc live. You can get there by typeing `cd` [enter]):
```bash
  $ cd
  $ echo "export PATH=$HOME/bin:$PATH" >> .bash_profile
```

If your `.bash_profile` does not exist, this will create it for you. Mac's will read this file, Ubuntu will not as I've figured out. You will have to call it from your `.bashrc` file or have your `.bashrc` file read your `.bash_profile` file (use the `source` command). If you are worried you don't see this file, it's because it's hidden. View a hidden file with the following

```bash
  $ ls -la
```

You will need to restart your terminal so that it reads in your .bash_profile file. You should now be able to call these programs from anywhere on your computer by simply typing the name of the program. 



### On Windows

I don't use windows at all. I think the easiest thing to do is to download git bash for windows ([link](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)). This will allow you to basically run a Ubuntu bash shell inside windows. This is not a virtual machine I guess, it's integrated into the system. This will allow you to run vim and commands you have in bash. 

You can also just run from the cmd line, but it's not near as useful as bash scripting. 

They are executable already so just type the name of the program without the .exe extension. You may also need to go [here](http://nce.ads.uga.edu/wiki/doku.php?id=faq.windows) to download the extra software you need. 







## How do I use the BLUPF90 programs?

You have to first run the parameter file for `renumf90`. This program (1) formats data and reorganizes, (2) trims, orders, and renumbers the pedigree, (3) writes a new parameter file (`renf90.par`). 

```bash
 $ renumf90 <<< my_par_file.par
```

This writes out 4 files, **renf90.par**, **renaddxx.par**, **renf90.dat**, **renf90.tables**. 

<ol>
<li>renf90.par    = recreated parameter file you give to other application programs</li>
<li>renaddxx.par  = (usually xx=02,03,04,etc.) renumbered pedigree file for application programs</li>
<li>renf90.dat    = renumbered data file for application programs and only needed data</li>
<li>renf90.tables = recoded class variables with counts</li>
</ol>

Then run any program you want with `renf90.par`. 

```bash
 $ blupf90 <<< renf90.par
```

```bash
 $ remlf90 <<< renf90.par
```

```bash
 $ airemlf90 <<< renf90.par
```

```bash
 $ thrgibbs1f90 <<< renf90.par
```

etc...

This will output what you need. You can save output in Linux with:

```bash
 $ echo renf90.par | remlf90 | tee practice_reml_output.txt
```

I don't think Windows has a `tee` equivalent. 







## Tips and Hints

Always make sure 0's are missing in the pedigree. You can set missing value using 'OPTION missing -999' at the end of the renumf90 parameter files to change for your dataset, not the pedigree.

Make sure you don't have headers on files. Headers are the devil. 

Make sure everything is a simple space delimited file with no other stuff in it (tabs, etc).

Always add 'WEIGHT(S)' with an extra empty line below it (if not using them). Use the order on their website. 











## Example

The following is an example parameter file for BLUPF90. This is a two trait example. 

![](/Screenshots/parameter_file.png)

The program works by **keywords**. The 

* DATAFILE: specifies the name of the datafile
* TRAITS: column numbers for response traits to analyze
* FIELDS_PASSED TO OUTPUT: Column numbers for original values in the datafile to be copied to the new datafile (renumf90 recodes raw data to 1,2,3,...,n format. Nice to have for original IDs of animals. 
* WEIGHT(S): Column number for weighted analysis. NEED to keep a blank line if you don't run it. 
* RESIDUAL_VARIANCE: starting values for residual variances (start higher)
* EFFECT: Column numbers for fixed/random effects
* RANDOM: Keyword needs to be animal or diagonal (sire but not sure it's implemented)
* FILE: Name of pedigree file
* FILE_POS: Column number in pedigree for (1) Animal (2) Sire (3) Dam (4) Alt Dam (5) Year of Birth
* PED_DEPTH: Number of generations to search back in the pedigree (default 3), 0 will load entire 
* (CO)VARIANCES: Starting effects for random effect variances, usually animal effect first
* OPTION: Any options available for renumf90 or application programs (remlf90, airemlf90)

Since it's a 2 trait analaysis, there are 2 2x2 blocks for starting values for residual and genetic variances. If you want to add an effect to both traits, you must add the column number for that effect for both traits "2 2 cross alpha". If you want to only add it to one of the traits (response), you need to put a 0 for one of them like "14 0 cov". For class traits you need to add the "cross alpha" and for covariates you need to add "cov" after the column numbers. 

"FILE_POS 1 2 3 0 0" indicates that the animal sire and dam are in columns 1, 2, and 3 respectively. There is no alt dam or year of birth in the pedigree file. If you had year of birth in the pedigree file (4 columns), it would be "FILE_POS 1 2 3 0 4". 

You will see that there is one option in magenta at the bottom. These are options for renumf90, most options are for the application programs and simply get passed on to those programs through `renf90.par`. The only 3 options that are for renumf90 are `alpha_size`, `max_string_readline`, and `max_field_readline`. 




## Input Files

These are simply space delimited files with NO header. I write out a separate file from R with 1 column name per line to remember what columns are which. Then use `cat -n file.hd` to number each one. 

Here is a view of the data with missing as -999. You can add this as `OPTION missing -999` in the parameter file. 

![](/Screenshots/data.png)

Here is a view of the pedigree with animal, sire, and dam. 0 is missing for the pedigree no matter what you set for the data file. 00 will be treated as an actual ID I believe. Be careful. 

![](/Screenshots/pedigree.png)

Genotype files are 0,1,2, and 5 (missing) with no spaces. All the genotypes MUST start at the same character (lets say 20). So all of your IDs will have to fit in the first 18 characters (at least 1 space in between). 


![](/Screenshots/blupf90_genotypes.png)

These are imputed so no missing values. But the missing value would be 5. 

You can use the following command with `awk` to get them lined up!
```bash
awk ' { printf "%-20s %s\n", $1, $3 } ' my_file.mrk > new_file.mrk
```

## Output Files from renumf90

It outputs the following files:
1. renf90.par - new parameter file for application programs
2. renf90.dat - new data file
3. renf90.tables - counts and recoded ID number (1,2,3,...,n) with original ID (A, B, C, etc.)
4. renaddXX.ped - new pedigree file (10 columns with various information)






## Output Files from application programs

They output various files:
1. solutions - EBVs from blupf90 or final estimates from airemlf90 or other program
2. gibbs_samples - from gibbs sampling programs
3. various log files such as remlf90.log or aireml.log
4. fortxxx files (not sure what they are)
5. fspak files (this is for matrix inversion, not sure why it's not deleted)

There are probably other files I'm missing. Most of the needed output is from stdout from the programs. You can capture with 
commands such as:
```shell
echo renf90.par | airemlf90 | tee project.mytrait.aireml.out
```
and this will save the output with a naming convention I like to use which is project name (something short), the trait(s) name, and then program name and .out at the end. This way you can move all files into subdirectories or whatever you need. 





## Tips for thrgibbs1f90 and family

Threshold models can deal with non-normallly distributed traits. It should be binary or *ordered* categorical. This can be tricky. 0 is still missing for these programs for some unknown reason. So if you have 0/1 for a binary trait. 

How do I write the inputs into a script? If you like writing scripts like I do, you will need this. I like using the following:

```bash
thrgibbs1f90 <<EOF > $basename.$trait1.gibbs_samples
renf90.par
$n_samples $burnin
$store
EOF
```


### Tips for postgibbsf90

`postgibbsf90` is a software written to process samples from the gibbs sampling application programs. 

The only tricky part is that you need to input the same values you gave gibbs2f90, thrgibbs1f90, etc. so that it can process the gibbs samples from those programs. 






## Comments, Questions, or Problems?

Any help or suggestions are always welcome! Please email me if you have questions or comments (aputz [at] iastate [dot] edu)








