# what will this project be?
# maybe a small game? 
# lets strat with output
.global main 

.section .data

output_number:
    .ascii "%d\n\0"
first_number:
    .quad 3
    .quad 2

.section .text
main:
    # lets add two integers together using the same address
    #clear registers
    movq $0, %rbx
    movq $0, %rdx
    movq $0, %rcx
    movq first_number(,%rcx,8), %rbx    # get the first value from first_number 
    incq %rcx                           # increment the rcx register to next memory
    movq first_number(,%rcx,8), %rdx    # get the second value from the first_number
    addq %rbx, %rdx                     # add them together

print_output:
    movq stdout, %rdi
    movq $output_number, %rsi   # prints out a number format
    #movq result, %rdx               # the number to print
    movq $0, %rax               # rax must be zeroed out. Rax might be used for floating point numbers
    call fprintf

complete:
    movq $0, %rax               # rax must be zeroed out
    ret
