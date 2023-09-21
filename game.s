.global main 

.type print_output, @function
.type scan_input, @function

.section .data

start_game:
    .ascii "Start game? y/n\n\0"
input_start_game:
    .ascii "%s\0"
output_exit:
    .ascii "exit game\n\0"
.section .text

main:
    # game starts
    leaq start_game, %rdi
    call print_output

    #confirm
    leaq input_start_game, %rdi
    call scan_input 



complete:
    leaq output_exit, %rdi
    call print_output

    movq $0, %rax               # rax should be zeroed out
    ret


# param - %rdi -> output format
print_output:
    push %rdi
    movq stdout, %rdi
    pop %rsi          # rdi output format is put into rsi
    call fprintf
    ret

# get the input
# param - %rdi -> input format
# response - %rax -> result value
scan_input:
    enter $16, $0
    push %rdi
    movq stdin, %rdi
    pop %rsi
    
    leaq -8(%rbp), %rdx #put the input number into the stack frame local variable 1
    
    call fscanf

    movq %rdx, %rax
    leave
    ret
