.data
fmt_int:     .string "%d "       # format for printing each next-victim position
fmt_newline: .string "\n"        # newline at end of output

.text
.globl main

# Register map:
# s0 = num_students     (total number of students, argc - 1)
# s1 = iq_arr           (pointer to array of student IQs)
# s2 = next_victim      (pointer to result array: next_victim[i] = position of next misinformed student)
# s3 = crowtum_stk      (pointer to Crowtum's candidate stack, stores student indices)
# s4 = stk_top          (number of elements in stack; 0 = Crowtum has no candidates)
# s5 = argv             (saved copy of argv)
# s6 = student_idx      (current student being processed, loop counter)

main:
    addi sp, sp, -64
    sd ra, 56(sp)               # save return address
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
    slli a0, s0, 3              # a0 = num_students * 8
    call malloc
    mv s1, a0                   # s1 = iq_arr

    # allocate next_victim array (num_students * 8 bytes)
    slli a0, s0, 3
    call malloc
    mv s2, a0                   # s2 = next_victim

    # allocate crowtum_stk (num_students * 8 bytes)
    slli a0, s0, 3
    call malloc
    mv s3, a0                   # s3 = crowtum_stk

    li s4, 0                    # stk_top = 0 (Crowtum has no candidates yet)

    # parse argv[1..num_students] into iq_arr[], init next_victim[] to -1 
    li s6, 0                    # student_idx = 0
parse_loop:
    bge s6, s0, parse_done
    addi t0, s6, 1              # t0 = student_idx + 1 (offset into argv)
    slli t0, t0, 3
    add t0, s5, t0
    ld a0, 0(t0)                # a0 = argv[student_idx + 1] (IQ as string)
    call atoi                   # convert IQ string to integer
    slli t0, s6, 3
    add t0, s1, t0
    sd a0, 0(t0)                # iq_arr[student_idx] = parsed IQ
    li t1, -1
    slli t2, s6, 3
    add t2, s2, t2
    sd t1, 0(t2)                # next_victim[student_idx] = -1 (no next misinformed yet)
    addi s6, s6, 1              # student_idx++
    beq x0, x0, parse_loop

parse_done:
    # Crowtum scans students right to left 
    addi s6, s0, -1             # student_idx = num_students - 1

scan_loop:
    blt s6, x0, scan_done       # if student_idx < 0, Crowtum is done scanning

    # load iq_arr[student_idx] into t0
    slli t0, s6, 3
    add t0, s1, t0
    ld t0, 0(t0)                # t0 = current student's IQ

    # pop candidates whose IQ <= current student's IQ (they can't be the next victim)
pop_weaker:
    beq s4, x0, pop_done        # stack empty, no more candidates to check
    addi t1, s4, -1             # t1 = stk_top - 1
    slli t1, t1, 3
    add t1, s3, t1
    ld t1, 0(t1)                # t1 = index of top candidate
    slli t2, t1, 3
    add t2, s1, t2
    ld t2, 0(t2)                # t2 = IQ of top candidate
    blt t0, t2, pop_done        # top candidate has strictly greater IQ, stop popping
    addi s4, s4, -1             # pop: top candidate is not a valid next victim
    beq x0, x0, pop_weaker

pop_done:
    # if stack not empty, top candidate is the next student Crowtum will misinform
    beq s4, x0, push_candidate  # no valid next victim found
    addi t1, s4, -1
    slli t1, t1, 3
    add t1, s3, t1
    ld t1, 0(t1)                # t1 = position of next misinformed student
    slli t2, s6, 3
    add t2, s2, t2
    sd t1, 0(t2)                # next_victim[student_idx] = that position

push_candidate:
    # push current student onto crowtum_stk as a future candidate
    slli t0, s4, 3
    add t0, s3, t0
    sd s6, 0(t0)                # crowtum_stk[stk_top] = student_idx
    addi s4, s4, 1              # stk_top++
    addi s6, s6, -1             # student_idx-- (move to previous student)
    beq x0, x0, scan_loop

scan_done:
    #print next_victim[] space-separated
    li s6, 0                    # student_idx = 0
print_loop:
    bge s6, s0, print_done
    slli t0, s6, 3
    add t0, s2, t0
    ld a1, 0(t0)                # next_victim[student_idx]
    la a0, fmt_int
    call printf                 # print position of next misinformed student
    addi s6, s6, 1              # student_idx++
    beq x0, x0, print_loop

print_done:
    la a0, fmt_newline
    call printf                 # newline after all results

    li a0, 0                    # return 0
    ld ra, 56(sp)               # restore all saved registers
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    ld s6, 0(sp)
    addi sp, sp, 64
    ret
