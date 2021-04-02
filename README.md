# rpg-stats

### What is this? 

A very simple "stat generator," example output: 
```
$ ./stats 
Str: 12
Dex: 10
Con: 13
Int: 9
Wis: 14
Cha: 9
Com: 16
```
 

### Why? 
I played a lot of TIS-100 and other Zachtronics games which gave me an itch to play around with assembly.  Every time I go to try to learn a new language, one of the first things I like to do is make a stat/character generator for tabletop RPGs.  I don't play them as much as much as I used to, but it is still one of my gotos.


### Requirements:
 - nasm - Compiler
 - ld - Linker
 - Linux Kernel 3.17+ - getrandom kernel call https://man7.org/linux/man-pages/man2/getrandom.2.html

### How to build the binary:
There's a Makefile included, but if you don't have make installed: 
``` 
$ nasm -f elf64 stats.asm -o stats.o 
$ ld -z separate-code stats.o -o stats
```
The nasm line is building the object code from the assembly instructions and the ld is linking the object code to a 64bit binary.  I did not try this on any other architecture, sorry.
