# what will this project be?
# maybe a small game? 
# lets strat with output
.global main 

.section .data

output_number:
    .ascii "%d\n\0"

output_character_info:
    .ascii "character %d is %d of age and %d in height\n\0"

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
    jz complete

    # get the character number
    movq characters_len, %rdx
    subq %rcx, %rdx
    addq $1, %rdx

    push %rcx
    # show selected character info
    movq CHARACTER_AGE(%rbx), %rcx 
    movq CHARACTER_HEIGHT(%rbx), %r8
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

complete:
    movq $0, %rax               # rax must be zeroed out
    ret
