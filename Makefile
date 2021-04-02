all: stats

ASM = nasm
ASM_ARCH = -f elf64
LD = ld
LD_FLAGS = -z noseparate-code

stats: stats.o
	$(LD) $(LD_FLAGS) stats.o -o stats
stats.o:
	$(ASM) $(ASM_ARCH) stats.asm -o stats.o
strip:
	strip -s stats
clean:
	\rm -ifv stats.o stats
