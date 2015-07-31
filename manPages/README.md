# man pages for BLUPF90 programs

These are NOT final. They have been a work in progress. I would label this 'beta' for now. 

## Instructions

### Mac OS X:

1. Find a directory that is in your manpath already (I cannot figure out how to 
alter the manpath on Mac OS X as easy as some people seem to say online, help wanted...)
2. Copy the man page (marked down) to a directory that man will search. Add a ".1" to the end. 
``` 
  $ sudo cp name_of_file /usr/local/share/man/man1/name_of_file.1
```
3. gzip that file you just copied:
```
  $ sudo gzip /usr/local/share/man/man1/name_of_file.1
```

OR you can run the `installUGAManPages` file.

1. Make it executable:
```
  $ chmod 775 installUGAManPages
```
2. Execute the bash script with:
```
  $ ./installUGAManPages
```

Note: It will ask you if you want to overwrite the file if it already exists (for when you update).

### Linux machines:

I need to find a manpath to put these in. 

## How to use

### Mac OS X:

They should be availbe with the man command:

```
  $ man renumf90
```

### Linux:

Same, just run:

```
  $ man renumf90
```

or whatever man page you are interested in.

Please contact me with problems or ways to improve these. 
