.global main 

.type print_output, @function
.type scan_input, @function

.section .data

#IO texts
start_game:
    .ascii "Start game? y/n\n\0"
input_start_game:
    .ascii "%c\0"
print_next:
    .ascii "game begins here\n\0"
print_round_begin:
    .ascii "round nr %d\n\0"
print_round_obstacle:
    .ascii "round obstacle %d with object type %d\n\0"
print_exit:
    .ascii "exit game\n\0"

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

    movq %rdi, %rsi
    movq stdin, %rdi
    
    leaq -8(%rbp), %rdx #put the input number into the stack frame local variable 1
    movq $0, %rax
    call fscanf

    movq -8(%rbp), %rdi  #put the input into rdx register
    movq %rdi, %rax
    leave
    ret
