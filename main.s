# what will this project be?
# maybe a small game? 
# lets strat with output
.global _start 

.section .data

output:
    .ascii "Hello\n"

.section .text
_start:
    movq $1, %rax       # write system call
    movq $1, %rdi       # field description standard out
    movq $output, %rsi  # pointer to outgoing address stored for buf. 
    movq $6, %rdx       # bytes to write out
    syscall

complete:
    movq $60, %rax # exit the program
    syscall
