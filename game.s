.global main 

.type print_output, @function
.type scan_input, @function
.type compare_strings, @function

.section .data

#IO texts
start_game:
    .ascii "Start game? y/n\n\0"
input_start_game:
    .ascii "%s\0"
input_obstacle_interact:
    .ascii "%s"
print_next:
    .ascii "game begins here\n\0"
print_round_begin:
    .ascii "round nr %d\n\0"
print_round_obstacle:
    .ascii "round obstacle %d with object type %d\n\0"
print_exit:
    .ascii "exit game\n\0"
print_debug:
    .ascii "rax is %c\n\0"

obstacles:
    .quad 1, 4
    .quad 2, 5
    .quad 3, 6
level:
    .quad 1, 1, 2, 3, 0
obstacle_index:
    .quad 0
active_obstacle:
    .quad 0
compare_string_one:
    .ascii "exit\0"
compare_string_two:
    .ascii "exit\0"

.section .text

main:
    # game starts
    #leaq start_game, %rdi
    #call print_output

    #confirm
    #leaq input_start_game, %rdi
    #call scan_input

    leaq compare_string_one, %rdi
    leaq compare_string_two, %rdx
    call compare_strings

    # check for scan_input nullpointer
    cmpq $0, %rax
    je complete


    leaq start_game, %rdi
    call print_output
    jmp complete

    # confirm and move on
    # cmpq $'y', %rax
    # jne complete

game_next:
    leaq print_next, %rdi
    call print_output
game_loop:
    #print new round info 
    leaq print_round_begin, %rdi
    movq obstacle_index, %rdx
    call print_output

    #update the active obstacle
    leaq obstacles, %r9
    leaq level, %rbx
    movq $2, %r8
    movq (%rbx, %r8, 8), %rax
    movq %rax, active_obstacle

    # print obstacle in round
    leaq print_round_obstacle, %rdi
    movq active_obstacle, %rdx

    #get the obstacle nr from obstacle list
    movq (%r9, %rdx, 8), %rcx #%rdx has the active obstacle number
    call print_output

scan_second_input:
    # wait for the user input
    leaq input_obstacle_interact, %rdi
    call scan_input

    cmpq $'a', %rax
    je game_loop 
    jne complete
complete:
    leaq print_exit, %rdi
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
   leaq -8(%rbp), %rsi
   movq $0, %rax

   call scanf

   movq -8(%rbp), %rax
   leave
   ret

# rdi -> string one
# rdx -> string two
# rax -> bool result
compare_strings:
    movq $0, %r8
loop:
    movb (%rdi), %al
    movb (%rdx), %bl

    # we hit the null value, end of string
    cmpb $0, %al
    je is_equal 

    cmpb %bl, %al
    jne is_not_equal 
    incq %rdi
    incq %rdx
    jne loop
is_equal:
    movq $1, %rax
    jmp return
is_not_equal:
    movq $0, %rax
    jmp return
return:
    ret

