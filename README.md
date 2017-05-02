# BLUPF90

Anything I do related to the BLUPF90 programs will be included in this repository. 

## What's included in this repository?

### 1 - vim syntax highlighting files

vim is the most common command line text editor for Mac OS X and Linux, although it can also exist on Windows computers. vim syntax highlighting files allow the user to see keywords highlighted in real time. This will hopefully eliminate one of the most common problems, which is spelling things wrong. For instance adding EFFETC in your parameter file instead of EFFECT. vim highlighting would display an error and it could be fixed immediately without ever running the parameter file. 

### 2 - man pages

Man pages are available on Mac OS X and Linux systems. I prefer them to the alternative info pages, which to me look like very poorly formated text files. Man pages are formatted much better and don't take you to a random page if that program doesn't exist. It's my hope that they will eventually have much more information than what their wiki currently has. I may just add documentation to this repository instead. 

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

Go to this [link](http://nce.ads.uga.edu/wiki/doku.php?id=start) --> Documentation --> here --> Your OS --> Needed folder

You should now be in a directory with the names of the programs. 

Click on any of the programs to download (save) them directly to your computer. 

### On Mac or Linux:

Go to the Downloads folder and convert them to an executable with:
```
  $ chmod 775 name_of_program
```

Once you have them as executable you can move them to your folder (directory) that you are working in and need to run the programs from. All you will need to do is add "./" in front of the name of the program. This tells your computer that the program is in the current working directory. 
```
  $ ./name_of_program
```

**Advanced!**

Make a ~/bin directory if you don't have one already
```
  $ cd
  $ mkdir bin
```

Move these programs you downloaded to your ~/bin/ or $HOME/bin directory (these are one in the same):
```
  $ mv ~/Downloads
  $ mv name_of_program ~/bin
```
Repeat the move command as many times as needed (for each program). 

Follow this up by adding a line to your .bash_profile (this file is in your home directory where Documents, Pictures, Downloads, etc live. You can get there by typeing `cd` [enter]):
```
  $ cd
  $ echo "export PATH=$HOME/bin:$PATH" >> .bash_profile
```
If your .bash_profile does not exist, this will create it for you. Mac's will read this file, Ubuntu will not as I've figured out. You will have to call it from your .bashrc file. If you are worried you don't see this file, it's because it's hidden. View a hidden file with the following
```
  $ ls -la
```
You will need to restart your terminal so that it reads in your .bash_profile file. You should now be able to call these programs from anywhere on your computer by simply typing the name of the program. 

### On Windows

Go luck, I don't work with Windows much at all. I know people who have and it seems pretty easy. 

They are executable already so just type the name of the program without the .exe extension. You may also need to go [here](http://nce.ads.uga.edu/wiki/doku.php?id=faq.windows) to download the extra software you need. 

## How do I use the BLUPF90 programs?

```
 $ renumf90 <<< my_par_file.par
```

This writes out 4 files, **renf90.par**, **readdxx.par**, **renf90.dat**, **renf90.tables**. 

<ol>
<li>renf90.par = recreated parameter file you give to other application programs</li>
<li>renaddxx.par = renumbered pedigre file for application programs</li>
<li>renf90.dat = renumbered data file for application programs</li>
<li>renf90.tables = recoded class variables with counts</li>
</ol>

Then run any program you want with renf90.par. 

```
 $ blupf90 <<< renf90.par
```

```
 $ remlf90 <<< renf90.par
```

```
 $ airemlf90 <<< renf90.par
```

This will output what you need. 

## Tips and Hints

Always make sure 0's are missing in the pedigree. You can set missing value using 'OPTION missing -999' at the end of the parameter files to change for your dataset, not the pedigree.

Make sure you don't have headers.

Make sure everything is a simple space delimited file with no other stuff in it (tabs, etc).

Always add 'WEIGHT(S)' with an extra empty line below it (if not using them). 

## Comments, Questions, or Problems?

Any help or suggestions are always welcome. Please email me if you have questions or comments (aputz@iastate.edu)

