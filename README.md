# BLUPF90

Anything I do related to the BLUPF90 programs will be included in this repository. 

## What's included in this repository?

### 1 - vim syntax highlighting files

vim is the most common command line text editor for Mac OS X and Linux, although it can also exist on Windows computers. vim syntax highlighting files allow the user to see keywords highlighted in real time. This will hopefully eliminate one of the most common problems, which is spelling things wrong. For instance adding EFFETC in your parameter file instead of EFFECT. vim highlighting would display an error and it could be fixed immediately without ever running the parameter file. 

### 2 - man pages

Man pages are available on Mac OS X and Linux systems. I prefer them to the alternative info pages, which to me look like very poorly formated text files. Man pages are formatted much better and don't take you to a random page if that program doesn't exist. It's my hope that they will eventually have much more information than what their wiki currently has. I may just add documentation to this repository instead. 

## How do I download the BLUPF90 programs?

Go to this [link](http://nce.ads.uga.edu/wiki/doku.php?id=start) --> Documentation --> here --> Your OS --> Needed folder

You should now be in a directory with the names of the programs. 

Click on any of the programs to download (save) them directly to your computer. 

**On Mac or Linux:**

Go to the Downloads folder and convert them to an executable with:
```
  $ chmod 775 name_of_program
```

Once you have them as executable you can move them to your folder (directory) that you are working in and need to run the programs from. All you will need to do is add "./" in front of the name of the program. This tells your computer that the program is in the current working directory. 
```
  $ ./name_of_program
```

Advanced! 

Move these programs to your ~/bin/ or $HOME/bin directory (these are one in the same):
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
If your .bash_profile does not exist, this will create it for you. Mac's will read this file, Ubuntu will not as I've figured out. You will have to call it from your .bashrc file. If you are worried you don't see this file, it's because it's hidden. View a hidden file with the following:
```
  $ ls -la
```
You should now be able to download

**On Windows**

They are executable already so just type the name of the program without the .exe extension. You may also need to go [here](http://nce.ads.uga.edu/wiki/doku.php?id=faq.windows) to download the extra software you need. 

Any help or suggestions are always welcome. Please email me if you have questions or comments. 

