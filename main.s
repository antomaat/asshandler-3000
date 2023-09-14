# what will this project be?
# maybe a small game? 
# lets strat with output
.global main 

.section .data

output_number:
    .ascii "%d\n\0"
first_number:
    .quad 3
    .quad 3

.section .text
main:
    # lets add two integers together using the same address
    #clear registers
    movq $0, %rbx
    movq $0, %rdx
    movq $first_number, %rbx    # save the mem address of first_number to reg
    movq (%rbx), %rdx           # get the value from the rbx reg
    addq $8, %rbx               # update the register address to the next quad
    addq (%rbx), %rdx

print_output:
    movq stdout, %rdi
    movq $output_number, %rsi   # prints out a number format
    #movq result, %rdx               # the number to print
    movq $0, %rax               # rax must be zeroed out. Rax might be used for floating point numbers
    call fprintf

complete:
    movq $0, %rax               # rax must be zeroed out
    ret
