global _start

; Mostly system calls and constants

SYS_READ	equ 0
SYS_WRITE	equ 1
SYS_EXIT	equ 60
STDOUT	equ 1
SYS_GETRANDOM	equ 318
GRND_RANDOM	equ 2

;
; strings for output
;
SECTION .data
stat1: db "Str: "
stat2: db "Dex: "
stat3: db "Con: "
stat4: db "Int: "
stat5: db "Wis: "
stat6: db "Cha: "
stat7: db "Com: "
stat_len equ 5
stat_array: dq stat1, stat2, stat3, stat4, stat5, stat6, stat7
;
; For printing integer strings 
;
SECTION .bss
num resb 1
digitSpace resb 64
empty resb 1
digitSpacePos resb 1
;
; Program
;
SECTION .text

_start:
; initialize counter
mov r8, 0
lea r9, [stat_array]
mov r10, 0

_stats:
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, [r9+r10]
mov rdx, stat_len
syscall

; roll our dice
call _gen_stat

inc r8
add r10, 8
cmp r8,7
jl _stats

jmp _quit

_gen_stat:
; roll and add 3d6, print and return
mov r12, 0
call _roll

add r12, rax
call _roll

add r12, rax
call _roll

add r12, rax

mov rax,r12
call _print_int
ret

_roll:
; generate a random 0 - 5 number +1 
call _rand
;call _print_int
cmp rax, 5
jg _roll
inc rax
ret

_rand:
mov QWORD [num], 0      ; Get a random number 
mov rax, SYS_GETRANDOM	; ssize_t getrandom(void *buf, size_t buflen, unsigned int flags);
mov rdi, num	        ; buf
mov rsi, 1	            ; 1 byte:  0 - 255
mov rdx, GRND_RANDOM	; GRND_RANDOM | GRND_NONBLOCK
syscall

mov rax, [num]
ret

;
;  Function _print_int converts an integer to a string to print to the screen
;
_print_int:
;mov r14, rax
mov rcx, digitSpace
mov rbx, 10
mov [rcx], rbx
inc rcx
mov [digitSpacePos], rcx

_div_loop:
mov rdx, 0
mov rbx, 10
div rbx
push rax
add rdx, 48

mov rcx, [digitSpacePos]
mov [rcx], dl
inc rcx
mov [digitSpacePos], rcx

pop rax
cmp rax, 0
jne _div_loop

_cha_loop:
mov rcx, [digitSpacePos]

mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, rcx
mov rdx, 1
syscall

mov rcx, [digitSpacePos]
dec rcx
mov [digitSpacePos], rcx

cmp rcx, digitSpace
jge _cha_loop

ret

; ################################################################
; ################################################################
; ################################################################

_quit:
mov rax, SYS_EXIT	; void _exit(int status);
mov rdi, 0	; status
syscall
