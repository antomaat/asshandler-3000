# what will this project be?
# maybe a small game? 
# lets strat with output
.global main 
.globl func_test
.type func_test, @function
.type func_input, @function
.type func_show_input_message, @function
.type func_input_heap, @function

.section .data

output_number:
    .ascii "%d\n\0"

output_character_info:
    .ascii "character %d is %d of age and %d in height. Special char %d\n\0"
input_character_type:
    .ascii "pick a character by number\n\0"
input_format:
    .ascii "%d\0"
output_character_picked:
    .ascii "You picked %d\n\0"

first_number:
    .quad 3
    .quad 2

picked_character:
    .quad 0
characters_len:
    .quad (characters_end-characters)/CHARACTERS_RECORD
characters:
    .quad 35, 180
    .quad 20, 120
characters_end:

.equ CHARACTERS_RECORD, 16
.equ CHARACTER_AGE, 0
.equ CHARACTER_HEIGHT, CHARACTER_AGE + 8

.section .text
main:
    movq characters_len, %rcx   # reg rcx holds the loop counter
    leaq characters, %rbx # point to the character
loop:
    addq $0, %rcx #to check if loop is 0
    jz wait_input 

    # get the character number
    movq characters_len, %rdx
    subq %rcx, %rdx
    addq $1, %rdx

    push %rcx
    # show selected character info
    movq CHARACTER_AGE(%rbx), %rcx 
    movq CHARACTER_HEIGHT(%rbx), %r8

    #test out how functions work
    call func_test
    movq %rax, %r9


print_output:
    movq stdout, %rdi
    leaq output_character_info, %rsi # prints out the character info
    #movq result, %rdx               # the number to print
    movq $0, %rax               # rax must be zeroed out. Rax might be used for floating point numbers
    call fprintf

    addq $CHARACTERS_RECORD, %rbx
    pop %rcx

    decq %rcx

    jmp loop
wait_input:
    call func_show_input_message
    call func_input
    call func_input_heap

complete:
    movq $0, %rax               # rax must be zeroed out
    ret

func_show_input_message:
    movq stdout, %rdi
    movq $input_character_type, %rsi
    movq $0, %rax
    call fprintf
    ret

func_input:
    enter $8, $0
    # get the number from input
    movq stdin, %rdi
    movq $input_format, %rsi
    leaq -8(%rbp), %rdx #put the input number into the stack frame local variable 1

    movq $0, %rax
    call fscanf

    #print the input out again
    push %rdx #stack rdx pointer
    movq -8(%rbp), %rdx  #put the input into rdx register
    movq stdout, %rdi
    movq $output_character_picked, %rsi
    movq $0, %rax
    call fprintf

    pop %rdx #pop the rdx pointer back out
    leave
    ret

func_input_heap:
    movq $500, %rdi
    call malloc

    movq stdin, %rdi
    movq $input_format, %rsi
    movq 8(%rax), %rdx #put the input number into the stack frame local variable 1
    push %rax # push the heap memory pointer to the stack for not losing it

    call fscanf

    pop %rax # pop the heap memory pointer out of stack

    movq 8(%rax), %rdx  #put the input into rdx register
    movq stdout, %rdi
    movq $output_character_picked, %rsi

    push %rax
    call fprintf
    pop %rax
    movq %rax, %rdi #rax holds the heap pointer. move it to rdi for free input
    call free
    ret
    

func_test:
    enter $16, $0       #not neccessary to add stack frames for now, but still doing it
    movq $0, %rax
    #use the stack to store local variables?
    movq $2, -8(%rbp) #local variable nr 1
    movq $5, -16(%rbp) #local variable nr 1

    addq -8(%rbp), %rax       #move 
    addq -16(%rbp), %rax       #move 

    leave
    ret
