.global main 

.type print_output, @function
.type scan_input, @function

.section .data

start_game:
    .ascii "Start game? y/n\n\0"
input_start_game:
    .ascii "%c\0"
output_next:
    .ascii "game begins here\n\0"
output_exit:
    .ascii "exit game\n\0"
.section .text

main:
    # game starts
    leaq start_game, %rdi
    call print_output

    #confirm
    movq $input_start_game, %rdi
    call scan_input

    # check for scan_input nullpointer
    cmpq $0, %rax
    je complete

    cmpq $'y', %rax
    jne complete


game_next:
    leaq output_next, %rdi
    call print_output

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
    enter $8, $0

    movq %rdi, %rsi
    movq stdin, %rdi
    
    leaq -8(%rbp), %rdx #put the input number into the stack frame local variable 1
    movq $0, %rax
    call fscanf

    movq -8(%rbp), %rdi  #put the input into rdx register
    movq %rdi, %rax
    leave
    ret
