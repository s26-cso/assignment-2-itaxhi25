.data
fmt_int:     .string "%d"
fmt_space:   .string " "
fmt_newline: .string "\n"

.text
.globl main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)
    sd s6, 0(sp)

    addi s0, a0, -1             # num_students = argc - 1
    mv s5, a1                   # save argv

    # allocate iq_arr (num_students * 8 bytes)
    slli a0, s0, 3
    call malloc
    mv s1, a0

    # allocate next_victim array (num_students * 8 bytes)
    slli a0, s0, 3
    call malloc
    mv s2, a0

    # allocate crowtum_stk (num_students * 8 bytes)
    slli a0, s0, 3
    call malloc
    mv s3, a0

    li s4, 0                    # stk_top = 0

    # parse argv[1..num_students] into iq_arr[], init next_victim[] to -1
    li s6, 0
parse_loop:
    bge s6, s0, parse_done
    addi t0, s6, 1
    slli t0, t0, 3
    add t0, s5, t0
    ld a0, 0(t0)
    call atoi
    slli t0, s6, 3
    add t0, s1, t0
    sd a0, 0(t0)                # iq_arr[student_idx] = parsed IQ
    li t1, -1
    slli t2, s6, 3
    add t2, s2, t2
    sd t1, 0(t2)                # next_victim[student_idx] = -1
    addi s6, s6, 1
    beq x0, x0, parse_loop

parse_done:
    addi s6, s0, -1             # student_idx = num_students - 1

scan_loop:
    blt s6, x0, scan_done

    # load iq_arr[student_idx]
    slli t0, s6, 3
    add t0, s1, t0
    ld t0, 0(t0)                # t0 = current student's IQ

pop_weaker:
    beq s4, x0, pop_done
    addi t1, s4, -1
    slli t1, t1, 3
    add t1, s3, t1
    ld t1, 0(t1)                # t1 = index of top candidate
    slli t2, t1, 3
    add t2, s1, t2
    ld t2, 0(t2)                # t2 = IQ of top candidate
    blt t0, t2, pop_done
    addi s4, s4, -1
    beq x0, x0, pop_weaker

pop_done:
    beq s4, x0, push_candidate
    addi t1, s4, -1
    slli t1, t1, 3
    add t1, s3, t1
    ld t1, 0(t1)                # t1 = index of next victim
    slli t2, s6, 3
    add t2, s2, t2
    sd t1, 0(t2)                # next_victim[student_idx] = t1

push_candidate:
    slli t0, s4, 3
    add t0, s3, t0
    sd s6, 0(t0)                # crowtum_stk[stk_top] = student_idx
    addi s4, s4, 1              # stk_top++
    addi s6, s6, -1             # student_idx--
    beq x0, x0, scan_loop

scan_done:
    li s6, 0

print_loop:
    bge s6, s0, print_done
    slli t0, s6, 3
    add t0, s2, t0
    ld a1, 0(t0)                # a1 = next_victim[student_idx]
    la a0, fmt_int
    call printf                 # print the value

    # print space only if not last element
    addi t2, s0, -1
    beq s6, t2, no_space
    la a0, fmt_space
    call printf
no_space:
    addi s6, s6, 1
    beq x0, x0, print_loop

print_done:
    la a0, fmt_newline          
    call printf

    li a0, 0
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    ld s6, 0(sp)
    addi sp, sp, 64
    ret
