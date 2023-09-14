# what will this project be?
# maybe a small game? 
# lets strat with output
.global main 

.section .data

output:
    .ascii "Hello"
world:
    .ascii "World\n"
output_number:
    .ascii "%d\n\0"
output_end:
    .ascii ""

.section .text
main:
    movq stdout, %rdi
    movq $output_number, %rsi   # prints out a number format
    movq %rsi, output_end
    movq output_end, %rsi 
    movq $5, %rdx               # the number to print
    movq $0, %rax               # rax must be zeroed out. Rax might be used for floating point numbers
    call fprintf

complete:
    movq $0, %rax               # rax must be zeroed out
    ret
