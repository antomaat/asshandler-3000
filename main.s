# what will this project be?
# maybe a small game? 
# lets strat with output
.global main 

.section .data

output_number:
    .ascii "%d\n\0"
first_number:
    .quad 3
second_number:
    .quad 5
result:
    .quad 0


.section .text
main:
    movq first_number, %rax
    addq second_number, %rax
    movq %rax, result

print_output:
    movq stdout, %rdi
    movq $output_number, %rsi   # prints out a number format
    movq result, %rdx               # the number to print
    movq $0, %rax               # rax must be zeroed out. Rax might be used for floating point numbers
    call fprintf

complete:
    movq $0, %rax               # rax must be zeroed out
    ret
