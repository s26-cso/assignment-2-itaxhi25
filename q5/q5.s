.data
joke_file:  .string "input.txt"
file_mode:  .string "r"
msg_yes:    .string "Yes\n"
msg_no:     .string "No\n"

.text
.globl main

# s0 = joke_fp
# s1 = front_ptr
# s2 = back_ptr

main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    la a0, joke_file
    la a1, file_mode
    call fopen
    mv s0, a0

    mv a0, s0
    li a1, 0
    li a2, 2            # SEEK_END
    call fseek

    mv a0, s0
    call ftell
    addi s2, a0, -1     # back_ptr points to last char

    li s1, 0            # front_ptr points to first char

compare_loop:
    bge s1, s2, its_a_palindrome

    mv a0, s0
    mv a1, s1
    li a2, 0            # SEEK_SET
    call fseek
    mv a0, s0
    call fgetc
    addi sp, sp, -8
    sd a0, 0(sp)        # spill front_char

    mv a0, s0
    mv a1, s2
    li a2, 0            # SEEK_SET
    call fseek
    mv a0, s0
    call fgetc

    ld t0, 0(sp)        # reload front_char
    addi sp, sp, 8
    bne t0, a0, not_a_palindrome

    addi s1, s1, 1
    addi s2, s2, -1
    beq x0, x0, compare_loop

not_a_palindrome:
    la a0, msg_no
    call printf
    beq x0, x0, done

its_a_palindrome:
    la a0, msg_yes
    call printf

done:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    ld s2, 0(sp)
    addi sp, sp, 32
    li a0, 0
    ret
