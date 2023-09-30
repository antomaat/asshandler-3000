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
print_action_jump:
    .ascii "You jumped on top of the obstacle\n\0"
obstacles:
    .quad 1, 1
    .quad 2, 2
    .quad 3, 1
level:
    .quad 1, 1, 2, 3, 0
level_end:
level_size:
    .quad (level_end-level) / 16
obstacle_index:
    .quad 0
active_obstacle:
    .quad 0
action_exit:
    .ascii "exit\0"
action_next:
    .ascii "next\0"
action_jump:
    .ascii "jump\0"
selected_action:
    .ascii "notexit\0"

player_health:
    .quad 2

obstacle_health:
    .quad 0

.globl OBSTACLE_HEALTH_INDX
.equ OBSTACLE_HEALTH_INDX, 8

.section .text

main:
    # game starts
    leaq start_game, %rdi
    call print_output

    #confirm
    #leaq input_start_game, %rdi
    #call scan_input

    #leaq action_exit, %rdi
    #movq %rax, selected_action
    #leaq selected_action, %rdx
    #call compare_strings

    # check for scan_input nullpointer
    #cmpq $0, %rax
    #je complete

game_next:
    leaq print_next, %rdi
    call print_output
game_loop:
    #print new round info 
    leaq print_round_begin, %rdi
    movq obstacle_index, %rdx
    call print_output

    # if obstacle index is bigger than level size, complete the game
    cmpq level_size, %rdx
    jae complete

    #update the active obstacle
    leaq obstacles, %r9
    leaq level, %rbx
    movq obstacle_index, %r8
    movq (%rbx, %r8, 8), %rax
    movq %rax, active_obstacle
    movq OBSTACLE_HEALTH_INDX(%rbx), %r10 
    movq %r10, obstacle_health

    # print obstacle in round
    leaq print_round_obstacle, %rdi
    movq active_obstacle, %rdx

    #get the obstacle nr from obstacle list
    movq (%r9, %rdx, 8), %rcx #%rdx has the active obstacle number
    call print_output

loop_input:
    # wait for the user input
    leaq input_obstacle_interact, %rdi
    call scan_input
    movq %rax, selected_action # add the input result to selected_action


loop_action_next:
    leaq selected_action, %rdx # add the input to register rdx
    # check for next action. If exists, do the next action
    leaq action_next, %rdi    
    call compare_strings        # compare if player entered "next"

    cmpq $1, %rax               # if next was typed, loop to the next round
    je update_loop_indx 
    jne loop_action_jump
loop_action_jump:
    # check for jump action
    leaq action_jump, %rdi    
    call compare_strings        # compare if player entered "next"

    cmpq $1, %rax               # if jump was typed, loop to the next round
    jne loop_input 

    leaq print_action_jump, %rdi
    call print_output

    # decrease obstacle health. Check if obstacle dead
    movq obstacle_health, %r9
    subq $1, %r9
    cmpq $0, %r9
    addq $1, %r8
    je update_loop_indx 
    jne loop_input

update_loop_indx:
    push %rdx

    #update the obstacle
    movq obstacle_index, %rdx
    addq $1, %rdx
    movq %rdx, obstacle_index
    pop %rdx
    jmp game_loop

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
# response - %rdx -> returns pointer to the scan input. Meant for comparison
scan_input:
   enter $8, $0

   leaq -8(%rbp), %rsi
   movq $0, %rax

   call scanf

   movq -8(%rbp), %rax
   movq (%rbp), %rdx

   leave
   ret

# rdi -> string one
# rdx -> string two
# rax -> bool result
compare_strings:
    push %rbx
    movq $0, %rax
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
    pop %rbx
    ret

